# frozen_string_literal: true

class PlatformCustomerOrderItemsController < ApplicationController
  include CustomerConcern
  before_action :authenticate_user!
  before_action :set_customer

  def index
    @platform_order_items = @platform_customer.platform_order_items.order(:id)
  end

  def edit
    @platform_order_item = @platform_customer.platform_order_items.find(params[:id])
    @platform_location = @platform_order_item.platform_order.platform_customer_site.platform_location
    @platform_order_item.platform_lift_events.build(latitude: @platform_location&.latitude, longitude: @platform_location&.longitude )
  end

  def update
    repo.update(params[:id], platform_order_item_params)
    redirect_to platform_customer_tabs_path(@platform_customer, params: {tab: "items"})
  end

  private

  def platform_order_item_params
    params.require(:platform_order_item).permit(:tag, platform_lift_events_attributes: [:id, :net_weight, :vehicle_code, :collection_date, :latitude, :longitude, :_destroy])
  end

  def repo
    @repo ||= PlatformOrderItemRepository.new(current_user)
  end
end
