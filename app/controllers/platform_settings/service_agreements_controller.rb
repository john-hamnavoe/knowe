# frozen_string_literal: true

class PlatformSettings::ServiceAgreementsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformServiceAgreement, "description asc")

    @pagy, @platform_service_agreements = pagy(@query.result(distinct: true), page: page)
  end

  def new
    ImportPlatformServiceAgreementsJob.perform_later(current_user, current_user.current_project, nil)
    redirect_to platform_settings_service_agreements_path, notice: "Service Agreement Import Queued!"
  end

  def show
    @service_agreement = repo.load(params[:id])
  end

  private

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
