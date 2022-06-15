# frozen_string_literal: true

class PlatformContractStatusAdapter < ApplicationAdapter
  def fetch
    import_contract_satuses
  end

  private

  def import_contract_satuses
    response = platform_client.query("integrator/erp/lists/contractStatuses")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |contract_satus|
        records << { project_id: project.id,
                     guid: contract_satus[:resource][:GUID],
                     description: contract_satus[:resource][:Description],
                     is_deleted: contract_satus[:resource][:IsDeleted] }
      end
      PlatformContractStatusRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformContractStatus", response.code)
  end
end
