# frozen_string_literal: true

class PlatformCustomerOrderItemsController < ApplicationController
  include CustomerConcern
  before_action :authenticate_user!
  before_action :set_customer

  def index
    @platform_order_items = @platform_customer.platform_order_items.order(:id)
  end
end
