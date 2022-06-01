# frozen_string_literal: true

class PlatformSettings::CustomerTemplatesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformCustomerTemplate, "description asc")

    @pagy, @platform_customer_templates = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformCustomerTemplateRepository.new(current_user)
  end

  def set_title
    @title = "Platform Customer Templates"
  end
end
