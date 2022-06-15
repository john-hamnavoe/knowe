# frozen_string_literal: true

class PlatformCompanyOutletAdapter < ApplicationAdapter
  def fetch
    import_companies
    import_company_outlets
  end

  private

  def import_companies
    response = platform_client.query("integrator/erp/lists/companies")
    return unless response.success?

    response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
    records = []
    response_data[:resource].each do |company|
      records << { project_id: project.id,
                   guid: company[:resource][:GUID],
                   description: company[:resource][:Description],
                   is_deleted: company[:resource][:IsDeleted],
                   analysis_code: company[:resource][:AnalysisCode] }
    end

    company_repo.import(records)
  end

  def import_company_outlets
    response = platform_client.query("integrator/erp/lists/outlets")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |outlet|
        company_id = company_repo.load_by_guid(outlet[:resource][:CompanyListItem][:Guid]).id
        records << { project_id: project.id,
                     guid: outlet[:resource][:GUID],
                     location_guid: outlet_location_guid(outlet[:resource][:GUID]),
                     description: outlet[:resource][:Description],
                     is_deleted: outlet[:resource][:IsDeleted],
                     analysis_code: outlet[:resource][:AnalysisCode],
                     vat_registration_number: outlet[:resource][:VATRegistrationNumber],
                     platform_company_id: company_id }
      end
      company_outlet_repo.import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformCompanyOutlet", response.code)
  end

  def outlet_location_guid(guid)
    supplier = suppliers.find { |x| x[:resource][:CompanyOutletListItem][:Guid] == guid }
    return nil unless supplier

    response = platform_client.query_with_filter("integrator/erp/directory/supplierSites", "filter=RelatedSupplierGuid eq '#{supplier[:resource][:GUID]}'")
    response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
    response_data[:resource][0][:resource][:RelatedLocationGuid]
  end

  def suppliers
    @suppliers ||= retrieve_suppliers
  end

  def retrieve_suppliers
    response = query_changes("integrator/erp/directory/suppliers/changes", nil, nil)
    response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0] if response.success?

    until response.cursor.nil?
      response = query_changes("integrator/erp/directory/suppliers/changes", nil, response.cursor)
      response_data.merge(JSON.parse("[#{response.body}]", symbolize_names: true)[0]) if response.success?
    end

    response_data[:resource].reject { |x| x[:resource][:CompanyOutletListItem].nil? }
  end

  def company_repo
    @company_repo ||= PlatformCompanyRepository.new(nil, project)
  end

  def company_outlet_repo
    @company_outlet_repo ||= PlatformCompanyOutletRepository.new(nil, project)
  end
end
