# frozen_string_literal: true

class PlatformContactTypeAdapter < ApplicationAdapter
  def fetch
    import_contact_types
  end

  private

  def import_contact_types
    response = platform_client.query("integrator/erp/lists/contactTypes")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |contact_type|
        records << { project_id: project.id,
                     guid: contact_type[:resource][:GUID],
                     description: contact_type[:resource][:Description] }
      end
      PlatformContactTypeRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformContactType", response.code)
  end
end
