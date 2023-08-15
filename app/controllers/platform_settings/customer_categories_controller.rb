# frozen_string_literal: true

class PlatformSettings::CustomerCategoriesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformCustomerCategory, "description asc")

    @pagy, @platform_customer_categories = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformCustomerCategoryRepository.new(current_user)
  end

  def set_title
    @title = "Platform Customer Categories"
  end
end
