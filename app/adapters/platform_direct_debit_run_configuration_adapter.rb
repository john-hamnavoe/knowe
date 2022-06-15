# frozen_string_literal: true

class PlatformDirectDebitRunConfigurationAdapter < ApplicationAdapter
  def fetch
    import_direct_debit_run_configurations
  end

  private

  def import_direct_debit_run_configurations
    response = platform_client.query("integrator/erp/lists/directDebitRunConfigurations")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |direct_debit_run_configuration|
        records << { project_id: project.id,

                     guid: direct_debit_run_configuration[:resource][:GUID],
                     description: direct_debit_run_configuration[:resource][:Description],
                     is_deleted: direct_debit_run_configuration[:resource][:IsDeleted] }
      end
      PlatformDirectDebitRunConfigurationRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformDirectDebitRunConfiguration", response.code)
  end
end
