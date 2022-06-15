# frozen_string_literal: true

class PlatformDepartmentAdapter < ApplicationAdapter
  def fetch
    import_departments
  end

  private

  def import_departments
    response = platform_client.query("integrator/erp/lists/departments")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |department|
        records << { project_id: project.id,
                     guid: department[:resource][:GUID],
                     description: department[:resource][:Description],
                     is_deleted: department[:resource][:IsDeleted] }
      end
      PlatformDepartmentRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformDepartment", response.code)
  end
end
