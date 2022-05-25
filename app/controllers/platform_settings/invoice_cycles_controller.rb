# frozen_string_literal: true

class PlatformSettings::InvoiceCyclesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_invoice_cycles_from_platform

  def index
    @query, page = ransack_query(PlatformInvoiceCycle, "description asc")

    @pagy, @platform_invoice_cycles = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_invoice_cycles_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "InvoiceCycles are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformInvoiceCycleRepository.new(current_user)
  end

  def set_title 
    @title = "Platform Invoice Cycles"
  end
end
