# frozen_string_literal: true

class PlatformDocumentDeliveryTypeAdapter < ApplicationAdapter
  def fetch
    import_document_delivery_types
  end

  private

  def import_document_delivery_types
    response = platform_client.query("integrator/erp/lists/documentDeliveryTypes")
    response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
    records = []
    response_data[:resource].each do |document_delivery_type|
      records << { project_id: project.id,
                   
                   guid: document_delivery_type[:resource][:GUID],
                   description: document_delivery_type[:resource][:Description],
                   is_active: document_delivery_type[:resource][:IsActive] }
    end
    PlatformDocumentDeliveryTypeRepository.new(nil, project).import(records)
  end
end
