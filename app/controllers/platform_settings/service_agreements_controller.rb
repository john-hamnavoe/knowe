# frozen_string_literal: true

class PlatformSettings::ServiceAgreementsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title
  before_action :reload_service_agreements_from_platform

  def index
    @query, page = ransack_query(PlatformServiceAgreement, "description asc")

    @pagy, @platform_service_agreements = pagy(@query.result(distinct: true), page: page)
  end

  def create
    ImportPlatformServiceAgreementsJob.perform_later(current_user, current_user.current_project, params[:company_outlet_guid]) if params && params[:company_outlet_guid].present?
    redirect_to platform_settings_service_agreements_path, notice: "Service Agreement Import Queued!"
  end

  def show
    @service_agreement = repo.load(params[:id])
  end

  private

  def reload_service_agreements_from_platform
    return if repo.all().count.positive? || outlet_repo.all().count.zero?

    flash[:notice] = "ServiceAgreements are being fetched!"
    outlet_repo.all().each do |outlet|
      ImportPlatformServiceAgreementsJob.perform_later(current_user, current_user.current_project, outlet.guid)
    end
  end

  def repo
    @repo ||= PlatformServiceAgreementRepository.new(current_user)
  end

  def outlet_repo
    @outlet_repo ||= PlatformCompanyOutletRepository.new(current_user)
  end

  def set_title 
    @title = "Platform Service Agreements"
  end
end
