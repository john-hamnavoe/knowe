# frozen_string_literal: true

class PlatformSettings::CustomerSiteStatesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformCustomerSiteState, "description asc")

    @pagy, @platform_customer_site_states = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformCustomerSiteStateRepository.new(current_user)
  end

  def set_title
    @title = "Platform Customer Site States"
  end
end
