# frozen_string_literal: true

class PlatformSettings::CustomerSiteStatesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_customer_site_states_from_platform

  def index
    @query, page = ransack_query(PlatformCustomerSiteState, "description asc")

    @pagy, @platform_customer_site_states = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_customer_site_states_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "Customer Site States are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformCustomerSiteStateRepository.new(current_user)
  end

  def set_title
    @title = "Platform Customer Site States"
  end
end
