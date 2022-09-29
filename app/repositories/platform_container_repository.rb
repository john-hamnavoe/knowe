# frozen_string_literal: true

class PlatformContainerRepository < ApplicationRepository
  def all(args={}, order_by="tag", direction="asc")
    query = PlatformContainer.where(project: project).where(args)

    query.order(order_by => direction)
  end

  def create(params)
    platform_container = PlatformContainer.new(params)
    platform_container.project = project
    platform_container.save
    platform_container
  end

  def load_or_create_by_tag(tag, params)
    platform_container = load_by_tag(tag)
    return platform_container if platform_container.present?

    platform_container = create(params)
    platform_container
  end    

  def update(id, params)
    platform_container = PlatformContainer.find_by(id: id,  project: project)
    platform_container&.update(params)
    platform_container
  end  

  def load(id)
    PlatformContainer.find_by(id: id, project: project)
  end

  def load_by_guid(guid)
    PlatformContainer.find_by(guid: guid, project: project)
  end

  def load_by_tag(tag)
    PlatformContainer.find_by(tag: tag, project: project)
  end

  def import(records)
    PlatformContainer.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:tag, :serial_no, :note, :latitude, :longitude, :is_stoplisted,
                                                                                                                  :is_commercial, :platform_container_status_id, :platform_container_type_id,
                                                                                                                  :platform_company_outlet_id] }, returning: :guid

    build_order_item_links
  end

  private

  def build_order_item_links
    ActiveRecord::Base.connection.exec_update(<<-EOQ)
    UPDATE platform_order_items
        SET platform_container_id = platform_containers.id, 
            tag = platform_containers.tag
      FROM platform_containers
      WHERE platform_order_items.related_container_guid = platform_containers.guid AND
            platform_order_items.project_id = platform_containers.project_id AND
            (platform_order_items.platform_container_id IS NULL OR
            (platform_order_items.platform_container_id != platform_containers.id))
    EOQ
  end
end
