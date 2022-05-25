# frozen_string_literal: true

class Platform::CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformCustomer, "name asc")

    @pagy, @platform_customers = pagy(@query.result(distinct: true).includes(:platform_customer_state, :platform_department), page: page)
  end

  def create
    ImportPlatformCustomersJob.perform_later(current_user, current_user.current_organisation, current_user.current_customer,  params[:account_codes].split(",")) if params && params[:account_codes].present?
    redirect_to platform_customers_customers_path, notice: "Customer Import Queued!"
  end

  def show
    @customer = repo.load(params[:id])
    @selected_site = @customer.platform_customer_sites&.find { |s| s.id == @selected_id }
  end

  private

  def set_title
    @title = "Customers"
  end
end
