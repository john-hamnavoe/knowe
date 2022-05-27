# frozen_string_literal: true

class PlatformCustomerLiftEventsController < ApplicationController
  include CustomerConcern
  before_action :authenticate_user!
  before_action :set_customer

  def index
    @platform_lift_events = @platform_customer.platform_lift_events.order(:collection_date)
  end
end
