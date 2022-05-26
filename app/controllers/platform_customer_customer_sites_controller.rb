# frozen_string_literal: true

class PlatformCustomerCustomerSitesController < ApplicationController
  include CustomerConcern
  before_action :authenticate_user!
  before_action :set_customer

  def index
    @platform_customer_sites = @platform_customer.platform_customer_sites.order(:name)
  end
end
