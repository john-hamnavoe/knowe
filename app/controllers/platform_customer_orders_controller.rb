# frozen_string_literal: true

class PlatformCustomerOrdersController < ApplicationController
  include CustomerConcern
  before_action :authenticate_user!
  before_action :set_customer

  def index
    @platform_orders = @platform_customer.platform_orders.order(:order_number)
  end
end
