# frozen_string_literal: true

class PlatformOrderAdapter < ApplicationAdapter
  def create(platform_order)
    return unless platform_order.guid.nil?

    response = post("integrator/erp/transport/orders", platform_order.as_platform_json)
    if response.success?
      platform_order.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_order.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end

  def fetch(guid)
    load_standing_data
    import_order(guid)
  end

  def fetch_by_account_number(account_numbers)
    load_standing_data
    import_orders(account_numbers)
  end

  def fetch_by_customer_guid(customer_guid)
    load_standing_data
    import_orders_by_customer_guid(customer_guid)
  end  

  def fetch_all(pages = nil)
    load_standing_data
    import_all_orders(bookmark_repo.find(PlatformBookmark::ORDER), pages)
  end

  private

  def import_order(guid)
    response = query("integrator/erp/transport/orders/#{guid}")
    return unless response.success?

    customer_site = customer_site_repo.load_by_guid(response.data[:resource][:RelatedSiteGuid])
    return if customer_site.nil?

    order, rentals, assignments, items = order_from_resource(response.data, customer_site.id)
    order_repo.import([order])

    # replace guids with ids
    platform_order = order_repo.load_by_guid(guid)
    rentals.each do |rental|
      rental[:platform_order_id] = platform_order.id
    end
    assignments.each do |assigment|
      assigment[:platform_order_id] = platform_order.id
    end
    items.each do |item|
      item[:platform_order_id] = platform_order.id
    end

    rental_repo.import(rentals)
    assignment_repo.import(assignments)
    item_repo.import(items)

    fetch_lifts_and_containers_for_items(items)
  end

  def import_orders(ar_account_codes)
    orders = []
    rentals = []
    assignments = []
    items = []
    ar_account_codes.each do |ar_account_code|
      customer = account_customer_repo.load_by_account_code(ar_account_code.strip)
      next if customer.nil?

      customer_sites = customer.platform_customer_sites

      customer_sites&.each do |customer_site|
        response = query_with_filter("integrator/erp/transport/orders", "filter=RelatedSiteGuid eq '#{customer_site.guid}'")
        next unless response.success?

        site_orders, site_rentals, site_assignments, site_items = orders_from_response(response.data, customer_site.id)
        orders += site_orders
        rentals += site_rentals
        assignments += site_assignments
        items += site_items
      end
    end

    create_orders(orders, rentals, assignments, items)
  end

  def import_orders_by_customer_guid(customer_guid)
    orders = []
    rentals = []
    assignments = []
    items = []
    customer = customer_repo.load_by_guid(customer_guid)
    return if customer.nil?

    customer_sites = customer.platform_customer_sites

    customer_sites&.each do |customer_site|
      response = query_with_filter("integrator/erp/transport/orders", "filter=RelatedSiteGuid eq '#{customer_site.guid}'")
      next unless response.success?

      site_orders, site_rentals, site_assignments, site_items = orders_from_response(response.data, customer_site.id)
      orders += site_orders
      rentals += site_rentals
      assignments += site_assignments
      items += site_items
    end


    create_orders(orders, rentals, assignments, items)
  end  

  def import_all_orders(bookmark, fetch_container_details = false, pages = nil)
    page = 1

    loop do 
      response = query_changes("integrator/erp/transport/orders/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
      orders, rentals, assignments, items = orders_from_response(response.data)
      create_orders(orders, rentals, assignments, items, fetch_container_details) if orders.length.positive?
      bookmark = bookmark_repo.create_or_update(PlatformBookmark::ORDER, response.until, response.cursor)

      break if response.cursor.nil? || (pages.present? && page >= pages)

      page += 1
    end
  end

  def create_orders(orders, rentals, assignments, items, fetch_container_details = true)
    order_repo.import(orders)

    # after orders saved set the platform_order_id to be new id on detail records
    saved_orders = order_repo.all({ guid: orders.map { |o| o[:guid] } })
    rentals.each do |rental|
      platform_order_id = saved_orders.find { |c| c.guid == rental[:platform_order_id] }&.id
      rental[:platform_order_id] = platform_order_id
    end
    assignments.each do |assignment|
      platform_order_id = saved_orders.find { |c| c.guid == assignment[:platform_order_id] }&.id
      assignment[:platform_order_id] = platform_order_id
    end
    items.each do |item|
      platform_order_id = saved_orders.find { |c| c.guid == item[:platform_order_id] }&.id
      item[:platform_order_id] = platform_order_id
    end

    rental_repo.import(rentals)
    assignment_repo.import(assignments)
    item_repo.import(items)

    fetch_lifts_and_containers_for_items(items) if fetch_container_details
  end

  def fetch_lifts_and_containers_for_items(items)
    lift_event_adapter = PlatformLiftEventAdapter.new(user, project)
    items.each do |item|
      lift_event_adapter.fetch_by_order_item(item[:guid])
    end

    container_adapter = PlatformContainerAdapter.new(user, project)
    items.each do |item|
      container_adapter.fetch_by_guid(item[:related_container_guid]) if item[:related_container_guid].present?
    end
  end

  def orders_from_response(response_data, parent_customer_site_id = nil)
    customer_sites = customer_site_repo.all({ guid: response_data[:resource].map { |r| r[:resource][:RelatedSiteGuid] } })
    records, rentals, assignments, items = [], [], [], []

    response_data[:resource].each do |order|
      customer_site_id = parent_customer_site_id || customer_sites.find { |cs| cs.guid == order[:resource][:RelatedSiteGuid] }&.id
      next if customer_site_id.nil?

      new_order, new_rentals, new_assignments, new_items = order_from_resource(order, customer_site_id)
      records << new_order
      rentals += new_rentals
      assignments += new_assignments
      items += new_items
    end
    return records, rentals, assignments, items
  end

  def order_from_resource(order, customer_site_id)
    rentals = []
    assignments = []
    items = []
    company_outlet_id = @company_outlets.find { |co| co.guid == order[:resource][:CompanyOutletListItem][:Guid] }&.id
    service_id = @services.find { |s| s.guid == order[:resource][:ServiceListItem][:Guid] }&.id
    material_id = @materials.find { |m| m.guid == order[:resource][:MaterialListItem][:Guid] }&.id
    service_agreement_id = @service_agreements.find { |cs| cs.guid == order[:resource][:RelatedServiceAgreementGuid] }&.id
    container_type_id = order[:resource][:DefaultContainerTypeListItem].present? ? @container_types.find { |c| c.guid == order[:resource][:DefaultContainerTypeListItem][:Guid] }&.id : nil
    priority_id =  order[:resource][:PriorityListItem].present? ? @priorities.find { |c| c.guid == order[:resource][:PriorityListItem][:Guid] }&.id : nil

    platform_order = { project_id: project.id,
                       guid: order[:resource][:GUID],
                       order_number: order[:resource][:OrderNumber],
                       customer_order_number: order[:resource][:CustomerOrderNumber],
                       ordered_by: order[:resource][:OrderedBy],
                       process_from: order[:resource][:ProcessFrom],
                       valid_until: order[:resource][:ValidUntil],
                       notes: order[:resource][:Notes],
                       driver_notes: order[:resource][:DriverNotes],
                       related_order_combination_grouping_guid: order[:resource][:RelatedOrderCombinationGroupingGuid],
                       related_service_agreement_guid: order[:resource][:RelatedServiceAgreementGuid],
                       platform_customer_site_id: customer_site_id,
                       platform_company_outlet_id: company_outlet_id,
                       platform_service_id: service_id,
                       platform_material_id: material_id,
                       platform_container_type_id: container_type_id,
                       platform_service_agreement_id: service_agreement_id,
                       platform_priority_id: priority_id }

    order[:resource][:ItemRentals].each do |rental|
      action_id = rental[:ActionListItem].present? ? @actions.find { |c| c.guid == rental[:ActionListItem][:Guid] }&.id : nil
      price_id = @prices.find { |c| c.guid == rental[:RelatedPriceGuid] }&.id
      container_type_id = rental[:ContainerTypeListItem].present? ? @container_types.find { |c| c.guid == rental[:ContainerTypeListItem][:Guid] }&.id : nil
      rentals << {
        project_id: project.id,
        guid: rental[:Guid],
        quantity: rental[:Quantity],
        start_date: rental[:StartDate],
        is_arrears: rental[:IsArrears],
        platform_action_id: action_id,
        platform_container_type_id: container_type_id,
        platform_price_id: price_id,
        platform_order_id: order[:resource][:GUID]
      }
    end

    order[:resource][:RouteAssignments].each do |assignment|
      action_id = assignment[:ActionListItem].present? ? @actions.find { |c| c.guid == assignment[:ActionListItem][:Guid] }&.id : nil
      container_type_id = assignment[:ContainerTypeListItem].present? ? @container_types.find { |c| c.guid == assignment[:ContainerTypeListItem][:Guid] }&.id : nil
      pickup_interval_id = assignment[:PickupIntervalListItem].present? ? @pickup_intervals.find { |c| c.guid == assignment[:PickupIntervalListItem][:Guid] }&.id : nil
      day_of_week_id = assignment[:DayOfWeekListItem].present? ? @day_of_weeks.find { |c| c.guid == assignment[:DayOfWeekListItem][:Guid] }&.id : nil
      route_template_id = @route_templates.find { |c| c.guid == assignment[:RelatedRouteTemplateGuid] }&.id
      assignments << {
        project_id: project.id,
        guid: assignment[:Guid],
        position: assignment[:Quantity],
        start_date: assignment[:StartDate],
        platform_action_id: action_id,
        platform_container_type_id: container_type_id,
        platform_pickup_interval_id: pickup_interval_id,
        platform_day_of_week_id: day_of_week_id,
        platform_route_template_id: route_template_id,
        platform_order_id: order[:resource][:GUID]
      }
    end

    order[:resource][:Containers].each do |container|
      container_type_id = container[:ContainerTypeListItem].present? ? @container_types.find { |c| c.guid == container[:ContainerTypeListItem][:Guid] }&.id : nil
      container_status_id = find_or_create_container_status_id(container[:ContainerStateListItem])
      items << {
        project_id: project.id,
        guid: container[:Guid],
        is_deleted: container[:IsDeleted],
        platform_container_type_id: container_type_id,
        platform_container_status_id: container_status_id,
        related_container_guid: container[:RelatedContainerGuid],
        platform_order_id: order[:resource][:GUID]
      }
    end

    return platform_order, rentals, assignments, items
  end

  def load_standing_data
    @company_outlets = PlatformCompanyOutletRepository.new(user, project).all
    @services = PlatformServiceRepository.new(user, project).all
    @actions = PlatformActionRepository.new(user, project).all
    @container_types = PlatformContainerTypeRepository.new(user, project).all
    @materials = PlatformMaterialRepository.new(user, project).all
    @prices = PlatformPriceRepository.new(user, project).all
    @pickup_intervals = PlatformPickupIntervalRepository.new(user, project).all
    @day_of_weeks = PlatformDayOfWeekRepository.new(user, project).all
    @route_templates = PlatformRouteTemplateRepository.new(user, project).all
    @service_agreements = PlatformServiceAgreementRepository.new(user, project).all
    @priorities = PlatformPriorityRepository.new(user, project).all
    @container_statuses = container_status_repo.all
  end

  def find_or_create_container_status_id(container_status)
    container_status_id = @container_statuses.find { |c| c.guid == container_status[:Guid] }&.id
    return container_status_id if container_status_id.present?

    container_status = container_status_repo.find_or_create(container_status[:Guid], container_status[:Description])
    @container_statuses = container_status_repo.all
    container_status.id
  end

  def container_status_repo
    @container_status_repo ||= PlatformContainerStatusRepository.new(user, project)
  end

  def customer_repo
    @customer_repo ||= PlatformCustomerRepository.new(user, project)
  end

  def account_customer_repo
    @account_customer_repo ||= PlatformAccountCustomerRepository.new(user, project)
  end

  def customer_site_repo
    @customer_site_repo ||= PlatformCustomerSiteRepository.new(user, project)
  end

  def order_repo
    @order_repo ||= PlatformOrderRepository.new(user, project)
  end

  def rental_repo
    @rental_repo ||= PlatformItemRentalRepository.new(user, project)
  end

  def assignment_repo
    @assignment_repo ||= PlatformRouteAssignmentRepository.new(user, project)
  end

  def item_repo
    @item_repo ||= PlatformOrderItemRepository.new(user, project)
  end

  def bookmark_repo
    @bookmark_repo ||= PlatformBookmarkRepository.new(user, project)
  end
end
