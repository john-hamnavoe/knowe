# frozen_string_literal: true

class PlatformSicCodeAdapter < ApplicationAdapter
  def fetch
    import_sic_codes
  end

  private

  def import_sic_codes
    page = 0

    loop do
      response = platform_client.query("integrator/erp/lists/sicCodes?max=200&page=#{page}")

      if response.success?
        response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
        records = []
        response_data[:resource].each do |sic_code|
          records << { project_id: project.id,
                       guid: sic_code[:resource][:GUID],
                       description_2007: sic_code[:resource][:Description2007],
                       code_2007: sic_code[:resource][:Code2007],
                       description_2003: sic_code[:resource][:Description2003],
                       code_2003: sic_code[:resource][:Code2003],
                       is_deleted: sic_code[:resource][:IsDeleted] }
        end
        platform_sic_code_repository.import(records)
      end

      page += 1

      platform_setting_repository.update_last_response("PlatformSicCode", response.code)

      break if !response.success? || response_data[:resource].empty?
    end
  end

  def platform_sic_code_repository
    @platform_sic_code_repository ||= PlatformSicCodeRepository.new(nil, project)
  end

  def platform_setting_repository
    @platform_setting_repository ||= PlatformSettingRepository.new(nil, project)
  end
end
