class Dashboard::LiftEvent::ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @activities = PlatformLiftEvent.joins(platform_order_item: {platform_order: :platform_material}).group("platform_materials.description").group_by_month(:collection_date).sum(:net_weight)
  end
end
