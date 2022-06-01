# frozen_string_literal: true

class PlatformSettings::CustomerStatesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformCustomerState, "description asc")

    @pagy, @platform_customer_states = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformCustomerStateRepository.new(current_user)
  end

  def set_title
    @title = "Platform Customer States"
  end
end
