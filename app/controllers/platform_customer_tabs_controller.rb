# frozen_string_literal: true

class PlatformCustomerTabsController < ApplicationController
  include CustomerConcern
  before_action :authenticate_user!
  before_action :set_customer

  def index
    tab = params[:tab]

    case tab
    when "editor"
      @path = params[:path]
      @target_frame = params[:target_frame]
    when "lifts"
      @path = platform_account_customer_lift_events_path(@platform_customer)
      @target_frame = "lifts"
    when "sites"
      @path = platform_account_customer_customer_sites_path(@platform_customer)
      @target_frame = "sites"
    when "contacts"
      @path = platform_account_customer_contacts_path(@platform_customer)
      @target_frame = "contacts"
    when "assignments"
      @path = platform_account_customer_route_assignments_path(@platform_customer)
      @target_frame = "assignments"
    when "rentals"
      @path = platform_account_customer_item_rentals_path(@platform_customer)
      @target_frame = "rentals"
    when "items"
      @path = platform_account_customer_order_items_path(@platform_customer)
      @target_frame = "items"
    else
      @path = platform_account_customer_orders_path(@platform_customer)
      @target_frame = "orders"
    end
  end
end
