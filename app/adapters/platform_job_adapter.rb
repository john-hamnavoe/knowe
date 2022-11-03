# frozen_string_literal: true

class PlatformJobAdapter < ApplicationAdapter
  def create(platform_job)
    return unless platform_job.guid.nil?

    response = post("integrator/erp/transport/jobs", platform_job.as_platform_json)
    if response.success?
      platform_job.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_job.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end

  def fetch_all(pages = nil)
    import_all_jobs(bookmark_repo.find(PlatformBookmark::JOB), pages)
  end

  def complete(platform_job)
    body = {
      "IsCompleted": true,
      "IsConfirmed": true,
      "IsFinanciallyConfirmed": true,
      "CompletedDate": Time.zone.today,
      "GUID": platform_job.guid
    }

    body = body.merge({ "PriceOverrides": [
      {
        "RelatedPriceGuid": platform_job.related_price_guid,
        "Guid": platform_job.price_override_guid,
        "OverrideRate": platform_job.override_rate.to_f,
        "IsSelected": true
      }
    ]}) if platform_job.price_override_guid.present? && platform_job.override_rate.present?
    
    response = put("integrator/erp/transport/jobs", platform_job.guid, body.to_json)
    if response.success?
      platform_job.update(is_completed: true, is_confirmed: true, is_financially_confirmed: true, last_response_body: response.body, last_response_code: response.code)
    else 
      platform_job.update(last_response_body: response.body, last_response_code: response.code)
    end      
    response
  end

  private

  def fetch_price_override(platform_job)
    return unless platform_job.guid.present?

    response = query("integrator/erp/transport/jobs/#{platform_job.guid}")
    if response.success?
      platform_job.update(price_override_guid: response.data[:resource][:PriceOverrides][0][:Guid])
    end
    response
  end

  def import_all_jobs(bookmark, pages)
    page = 1
    @company_outlets = PlatformCompanyOutletRepository.new(user, project).all
    @schedules = PlatformScheduleRepository.new(user, project).all
    @actions = PlatformActionRepository.new(user, project).all

    loop do
      response = query_changes("integrator/erp/transport/jobs/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
      job_repo.import(jobs_from_response(response.data)) if response.success?
      bookmark = bookmark_repo.create_or_update(PlatformBookmark::JOB, response.until, response.cursor)

      break if response.cursor.nil? || (pages.present? && page >= pages)
      
      page += 1
    end
  end

  def jobs_from_response(response_data)
    jobs = []
    response_data[:resource].each do |job|
      company_outlet_id = @company_outlets.find { |c| c.guid == job[:resource][:CompanyOutletListItem][:Guid] }&.id
      schedule_id = @schedules.find { |c| c.guid == job[:resource][:RelatedScheduleGuid] }&.id
      action_id = @actions.find { |c| c.guid == job[:resource][:ActionListItem][:Guid] }&.id
      jobs << { project_id: project.id,
                guid: job[:resource][:GUID],
                delete_route_assignments_on_completion: job[:resource][:DeleteRouteAssignmentsOnCompletion],
                in_progress: job[:resource][:InProgress],                            
                is_adhoc: job[:resource][:IsAdhoc],                              
                is_completed: job[:resource][:IsCompleted],                           
                is_confirmed: job[:resource][:IsConfirmed],                           
                is_external_transport: job[:resource][:IsExternalTransport],                  
                is_financially_confirmed: job[:resource][:IsFinanciallyConfirmed],               
                is_hazardous_paperwork_complete: job[:resource][:IsHazardousPaperworkComplete],
                is_scheduled_transfer: job[:resource][:IsScheduledTransfer],
                is_warranty: job[:resource][:IsWarranty], 
                related_site_order_guid: job[:resource][:RelatedSiteOrderGuid], 
                platform_action_id: action_id,
                platform_company_outlet_id: company_outlet_id,
                customer_order_no: job[:resource][:CustomerOrderNo], 
                date_required: job[:resource][:DateRequired],
                ticket_no: job[:resource][:TicketNo],
                hazardous_load_reference: job[:resource][:HazardousLoadReference],
                manual_ticket_no: job[:resource][:ManualTicketNo],
                notes: job[:resource][:Notes],
                po_number: job[:resource][:PONumber],
                quantity: job[:resource][:Quantity],
                related_location_destination_guid: job[:resource][:RelatedLocationDestinationGuid],
                related_schedule_guid: job[:resource][:RelatedScheduleGuid],
                platform_schedule_id: schedule_id }
    end

    jobs
  end

  def job_repo
    @job_repo || PlatformJobRepository.new(user, project)
  end

  def bookmark_repo
    @bookmark_repo || PlatformBookmarkRepository.new(user, project)
  end
end
