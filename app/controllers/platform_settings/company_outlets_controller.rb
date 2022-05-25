# frozen_string_literal: true

class PlatformSettings::CompanyOutletsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title
  before_action :reload_company_outlets_from_platform

  def index
    @query, page = ransack_query(PlatformCompanyOutlet, "description asc")

    @pagy, @platform_company_outlets = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_company_outlets_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "Company Outlets are being fetched!"
    ImportPlatformCompanyOutletsJob.perform_later(nil, current_user.current_project)
  end

  def repo
    @repo ||= PlatformCompanyOutletRepository.new(current_user)
  end

  def set_title
    @title = "Platform Company Outlets"
  end  
end
