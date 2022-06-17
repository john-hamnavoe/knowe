# frozen_string_literal: true

class PlatformDefaultActionAdapter < ApplicationAdapter
  def fetch
    import_default_actions
  end

  private

  def import_default_actions
    page = 0

    loop do
      response = platform_client.query("integrator/erp/lists/defaultActions?max=200&page=#{page}")

      if response.success?
        response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
        records = []
        response_data[:resource].each do |default_action|
          records << { project_id: project.id,
                       guid: default_action[:resource][:GUID],
                       platform_action_guid: default_action[:resource][:ActionListItem][:Guid],
                       platform_action_description: default_action[:resource][:ActionListItem][:Description],
                       platform_service_guid: default_action[:resource][:ServiceListItem][:Guid],
                       platform_service_description: default_action[:resource][:ServiceListItem][:Description],
                       platform_vat_guid: default_action[:resource][:VATListItem].present? ? default_action[:resource][:VATListItem][:Guid] : nil,
                       platform_vat_description: default_action[:resource][:VATListItem].present? ? default_action[:resource][:VATListItem][:Description] : nil,
                       platform_pricing_basis_guid: default_action[:resource][:PricingBasisListItem][:Guid],
                       platform_pricing_basis_description: default_action[:resource][:PricingBasisListItem][:Description],
                       platform_uom_guid: default_action[:resource][:UnitOfMeasureListItem].present? ? default_action[:resource][:UnitOfMeasureListItem][:Guid] : nil,
                       platform_uom_description: default_action[:resource][:UnitOfMeasureListItem].present? ? default_action[:resource][:UnitOfMeasureListItem][:Description] : nil,
                       platform_material_class_guid: default_action[:resource][:MaterialClassListItem].present? ? default_action[:resource][:MaterialClassListItem][:Guid] : nil,
                       platform_material_class_description: default_action[:resource][:MaterialClassListItem].present? ? default_action[:resource][:MaterialClassListItem][:Description] : nil
          }
        end
        platform_default_action_repository.import(records)
      end

      page += 1

      platform_setting_repository.update_last_response("PlatformDefaultAction", response.code)

      break if !response.success? || response_data[:resource].empty?
    end
  end

  def platform_default_action_repository
    @platform_default_action_repository ||= PlatformDefaultActionRepository.new(nil, project)
  end

  def platform_setting_repository
    @platform_setting_repository ||= PlatformSettingRepository.new(nil, project)
  end
end
