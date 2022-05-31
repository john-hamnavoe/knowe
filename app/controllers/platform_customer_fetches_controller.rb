# frozen_string_literal: true

class PlatformCustomerFetchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_title

  def new
  end

  def create
    FetchPlatformCustomersByAccountNumberJob.perform_later(current_user, current_user.current_project, platform_customer_fetch_params[:account_codes].split(",")) if platform_customer_fetch_params && platform_customer_fetch_params[:account_codes].present?
    flash[:notice] = "Customers are being fetched!" if platform_customer_fetch_params && platform_customer_fetch_params[:account_codes].present?
    redirect_to platform_customers_path
  end

  private

  def platform_customer_fetch_params
    params.require(:platform_customer_fetch).permit(:account_codes)
  end

  def set_title
    @title = "Fetch Customers"
  end
end

