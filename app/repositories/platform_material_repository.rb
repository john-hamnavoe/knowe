# frozen_string_literal: true

class PlatformMaterialRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformMaterial.where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load(id)
    PlatformMaterial.find_by(id: id,  project: project)
  end

  def load_by_guid(guid)
    PlatformMaterial.find_by(guid: guid,  project: project)
  end

  def load_by_description(description)
    platform_material = PlatformMaterial.find_by(description: description,  project: project)
    platform_material = PlatformMaterial.find_by(short_name: description,  project: project) if platform_material.nil?
    platform_material
  end

  def import(records)
    PlatformMaterial.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :short_name, :analysis_code, :is_deleted, :material_class_guid, :material_class_description] }, returning: :guid
  end
end
