# frozen_string_literal: true

class PlatformCustomerTabsController < ApplicationController
  include CustomerConcern
  before_action :authenticate_user!
  before_action :set_customer

  def index
    tab = params[:tab]

    case tab
    when "sites"
      @path = platform_customer_customer_sites_path(@platform_customer)
      @target_frame = "sites"
    when "contacts"
      @path = "#"
      @target_frame = "contacts"
    when "assignments"
      @path = platform_customer_route_assignments_path(@platform_customer)
      @target_frame = "assignments"
    when "rentals"
      @path = platform_customer_item_rentals_path(@platform_customer)
      @target_frame = "rentals"
    when "items"
      @path = platform_customer_order_items_path(@platform_customer)
      @target_frame = "items"
    else
      @path = platform_customer_orders_path(@platform_customer)
      @target_frame = "orders"
    end
  end
end
