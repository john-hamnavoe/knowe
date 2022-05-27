class CustomerDashboard::LiftEventsController < ApplicationController
  include CustomerConcern
  before_action :authenticate_user!
  before_action :set_customer

  def index
    query = PlatformLiftEvent.joins(platform_order_item: { platform_order: [:platform_customer_site, :platform_material] })
    query = query.where("collection_date >= :start_date", start_date: Time.zone.today - 6.months)
    query = query.where("platform_customer_sites.platform_customer_id = :platform_customer_id", platform_customer_id: @platform_customer.id)
    @material_weights = query.group("platform_materials.description").sum(:net_weight)
  end
end