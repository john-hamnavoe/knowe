# frozen_string_literal: true

class PlatformAccountCustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformAccountCustomer, "name asc")

    @pagy, @platform_customers = pagy(@query.result(distinct: true).includes(:platform_customer_state, :platform_department), page: page)
  end

  def show
    @customer = repo.load(params[:id])
    @selected_site = @customer.platform_customer_sites&.find { |s| s.id == @selected_id }
  end

  private

  def set_title
    @title = "Customers"
    @title_path = platform_account_customers_path
  end

  def repo
    @repo ||= PlatformAccountCustomerRepository.new(current_user)
  end
end
