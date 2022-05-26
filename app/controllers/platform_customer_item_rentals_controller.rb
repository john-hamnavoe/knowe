# frozen_string_literal: true

class PlatformCustomerItemRentalsController < ApplicationController
  include CustomerConcern
  before_action :authenticate_user!
  before_action :set_customer

  def index
    @platform_item_rentals = @platform_customer.platform_item_rentals.order(:id)
  end
end
