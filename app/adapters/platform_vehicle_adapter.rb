# frozen_string_literal: true

class PlatformVehicleAdapter < ApplicationAdapter
  def fetch
    import_vehicles
  end

  private

  def import_vehicles
    load_standing_data
    page = 0

    loop do
      response = platform_client.query("integrator/erp/fleet/vehicles?max=200&page=#{page}")

      if response.success?
        response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
        records = []
        response_data[:resource].each do |vehicle|
          company_outlet_id = @company_outlets.find { |c| c.guid == vehicle[:resource][:CompanyOutletListItem][:Guid] }&.id
          vehicle_type_id = @vehicle_types.find { |c| c.guid == vehicle[:resource][:VehicleTypeListItem][:Guid] }&.id
          records << { project_id: project.id,
                       guid: vehicle[:resource][:GUID],
                       registration_no: vehicle[:resource][:RegistrationNo],
                       vehicle_code: vehicle[:resource][:VehicleCode],
                       platform_company_outlet_id: company_outlet_id,
                       platform_vehicle_type_id: vehicle_type_id }
        end
        platform_vehicle_repository.import(records)
      end

      page += 1

      platform_setting_repository.update_last_response("PlatformVehicle", response.code)

      break if !response.success? || response_data[:resource].empty?
    end
  end

  def platform_vehicle_repository
    @platform_vehicle_repository ||= PlatformVehicleRepository.new(nil, project)
  end

  def platform_setting_repository
    @platform_setting_repository ||= PlatformSettingRepository.new(nil, project)
  end

  def load_standing_data
    @company_outlets = PlatformCompanyOutletRepository.new(user, project).all
    @vehicle_types = PlatformVehicleTypeRepository.new(user, project).all
  end
end
