# frozen_string_literal: true

class PlatformScheduleAdapter < ApplicationAdapter
  def initialize(user, project = nil)
    super(user, project)
    load_standing_data
  end

  def fetch  
    import_all_schedules(bookmark_repo.find(PlatformBookmark::SCHEDULE))
  end

  private

  def load_standing_data
    @company_outlets = PlatformCompanyOutletRepository.new(user, project).all
    @vehicles = PlatformVehicleRepository.new(user, project).all
  end

  def import_all_schedules(bookmark)
    loop do
      response = query_changes("integrator/erp/transport/schedules/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
      schedule_repo.import(schedules_from_response(response.data)) if response.success?
      bookmark = bookmark_repo.create_or_update(PlatformBookmark::SCHEDULE, response.until, response.cursor)

      break if response.cursor.nil?
    end
  end

  def schedules_from_response(response_data)
    schedules = []
    response_data[:resource].each do |schedule|
      company_outlet_id = @company_outlets.find { |c| c.guid == schedule[:resource][:CompanyOutletListItem][:Guid] }&.id
      vehicle_id = @vehicles.find { |c| c.guid == schedule[:resource][:RelatedVehicleGuid] }&.id
      schedules << { project_id: project.id,
                     guid: schedule[:resource][:GUID],
                     scheduled_date: schedule[:resource][:ScheduledDate],                 
                     description: schedule[:resource][:Description],                                                                                                                                 
                     is_completed: schedule[:resource][:IsCompleted],
                     is_container_schedule: schedule[:resource][:IsContainerSchedule],
                     is_for_vehicle: schedule[:resource][:IsForVehicle],
                     is_manifest_completed: schedule[:resource][:IsManifestCompleted],
                     is_manifest_exported: schedule[:resource][:IsManifestExported],
                     is_manifest_exported_failed: schedule[:resource][:IsManifestExportedFailed],
                     notes: schedule[:resource][:Notes],
                     leave_yard_time: schedule[:resource][:LeaveYardTime],
                     return_yard_time: schedule[:resource][:ReturnYardTime],
                     related_vehicle_guid: schedule[:resource][:RelatedVehicleGuid],
                     related_user_driver_guid: schedule[:resource][:RelatedUserDriverGuid],                                                                                           
                     platform_vehicle_id: vehicle_id,
                     platform_company_outlet_id: company_outlet_id }
    end

    schedules
  end

  def schedule_repo
    @schedule_repo ||= PlatformScheduleRepository.new(user, project)
  end

  def bookmark_repo
    @bookmark_repo ||= PlatformBookmarkRepository.new(user, project)
  end
end
