# frozen_string_literal: true

class PlatformCustomerRouteAssignmentsController < ApplicationController
  include CustomerConcern
  before_action :authenticate_user!
  before_action :set_customer

  def index
    @platform_route_assignments = @platform_customer.platform_route_assignments.order(:id)
  end
end
