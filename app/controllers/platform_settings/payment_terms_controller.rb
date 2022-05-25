# frozen_string_literal: true

class PlatformSettings::PaymentTermsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_payment_terms_from_platform

  def index
    @query, page = ransack_query(PlatformPaymentTerm, "description asc")

    @pagy, @platform_payment_terms = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_payment_terms_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "PaymentTerms are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformPaymentTermRepository.new(current_user)
  end

  def set_title 
    @title = "Platform Payment Terms"
  end
end
