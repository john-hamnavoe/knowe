# frozen_string_literal: true

class PlatformLiftEventAdapter < ApplicationAdapter
  def fetch_all(pages = nil)
    import_all_lift_events(bookmark_repo.find(PlatformBookmark::LIFT_EVENT), pages)
  end

  def fetch_by_order_item(order_item_guid)
    import_lift_events(order_item_guid)
  end

  private

  def import_lift_events(order_item_guid)
    response = query_with_filter("/integrator/erp/transport/liftEvents", "filter=RelatedSiteOrderContainerGuid eq '#{order_item_guid}'")
    lift_event_repo.import(lift_events_from_response(response.data)) if response.success?
  end

  def import_all_lift_events(bookmark, pages)
    page = 1
    response = query_changes("/integrator/erp/transport/liftEvents/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
    lift_event_repo.import(lift_events_from_response(response.data)) if response.success?

    until response.cursor.nil? || (pages.present? && page >= pages)
      response = query_changes("/integrator/erp/transport/liftEvents/changes", nil, response.cursor)
      lift_event_repo.import(lift_events_from_response(response.data))
      bookmark_repo.create_or_update(PlatformBookmark::LIFT_EVENT, response.until, response.cursor) if response.success?
      page += 1
    end

    bookmark_repo.create_or_update(PlatformBookmark::LIFT_EVENT, response.until, response.cursor) if response.success?
  end

  def lift_events_from_response(response_data, parent_order_item_id = nil)
    order_items = order_item_repo.all({ guid: response_data[:resource].map { |r| r[:resource][:RelatedSiteOrderContainerGuid] } })
    records = []
    response_data[:resource].each do |lift_event|
      order_item_id = parent_order_item_id || order_items.find { |c| c.guid == lift_event[:resource][:RelatedSiteOrderContainerGuid] }&.id

      new_lift_event = lift_event_from_resource(lift_event, order_item_id)
      records << new_lift_event
    end

    records
  end

  def lift_event_from_resource(lift_event, order_item_id)
    latitude = lift_event[:resource][:Location][:Lat] if lift_event[:resource][:Location].present?
    longitude = lift_event[:resource][:Location][:Long] if lift_event[:resource][:Location].present?

    {
      project_id: project.id,
      guid: lift_event[:resource][:GUID],
      charge_weight: lift_event[:resource][:ChargeWeight],
      net_weight: lift_event[:resource][:NetWeight],
      weight: lift_event[:resource][:Weight],
      quantity_collected: lift_event[:resource][:QuantityCollected],
      vehicle_code: lift_event[:resource][:VehicleCode],
      lift_text: lift_event[:resource][:LiftText],
      problem_text: lift_event[:resource][:ProblemText],
      information_text: lift_event[:resource][:InformationText],
      tag: lift_event[:resource][:Tag],
      collection_date: lift_event[:resource][:CollectionDate]&.to_date,
      collection_time_stamp: lift_event[:resource][:CollectionTimeStamp]&.to_time,
      related_route_guid: lift_event[:resource][:RelatedRouteGuid],
      related_route_visit_guid: lift_event[:resource][:RelatedRouteVisitGuid],
      related_site_order_container_guid: lift_event[:resource][:RelatedSiteOrderContainerGuid],
      is_deleted: lift_event[:resource][:IsDeleted],
      is_collected: lift_event[:resource][:IsCollected],
      latitude: latitude,
      longitude: longitude,
      platform_order_item_id: order_item_id
    }
  end

  def lift_event_repo
    @lift_event_repo ||= PlatformLiftEventRepository.new(user, project)
  end

  def order_item_repo
    @order_item_repo ||= PlatformOrderItemRepository.new(user, project)
  end

  def bookmark_repo
    @bookmark_repo ||= PlatformBookmarkRepository.new(user, project)
  end
end
