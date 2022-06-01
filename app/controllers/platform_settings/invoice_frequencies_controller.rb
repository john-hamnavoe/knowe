# frozen_string_literal: true

class PlatformSettings::InvoiceFrequenciesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformInvoiceFrequency, "description asc")

    @pagy, @platform_invoice_frequencies = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformInvoiceFrequencyRepository.new(current_user)
  end

  def set_title 
    @title = "Platform Invoice Frequencies"
  end
end
