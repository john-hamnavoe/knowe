# frozen_string_literal: true

class PlatformSettings::CustomerTypesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformCustomerType, "description asc")

    @pagy, @platform_customer_types = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformCustomerTypeRepository.new(current_user)
  end

  def set_title
    @title = "Platform Customer Types"
  end
end
