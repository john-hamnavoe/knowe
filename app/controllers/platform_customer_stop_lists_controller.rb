class PlatformCustomerStopListsController < ApplicationController
  include CustomerConcern
  before_action :authenticate_user!
  before_action :set_customer

  def index
    @on_stop_containers = 0
    @active_containers = 0
    order_items = @platform_customer.platform_order_items

    order_items.each do |order_item|
      @on_stop_containers += 1 if order_item.platform_container.present? && order_item.platform_container.is_stoplisted
      @active_containers += 1 if order_item.platform_container.present? && !order_item.platform_container.is_stoplisted
    end
  end

  def create
    repo.update_container_stop_status(params[:platform_account_customer_id], params[:stop_list][:is_stoplisted])
    PutPlatformUpdatesJob.perform_later(current_user, current_user.current_project)
    redirect_to platform_account_customer_stop_lists_path(@platform_customer)
  end

  private

  def repo
    @repo ||= PlatformAccountCustomerRepository.new(current_user)
  end
end