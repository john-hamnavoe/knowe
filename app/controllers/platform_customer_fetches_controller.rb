# frozen_string_literal: true

class PlatformCustomerFetchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_title

  def new
  end

  def create
    FetchPlatformCustomersByAccountNumberJob.perform_later(current_user, current_user.current_project, platform_customer_fetch_params[:account_codes].split(",")) if platform_customer_fetch_params && platform_customer_fetch_params[:account_codes].present?
    flash[:notice] = "Customers are being fetched!" if platform_customer_fetch_params && platform_customer_fetch_params[:account_codes].present?
    redirect_to platform_account_customers_path
  end

  def update
    platform_customer = customer_repo.load(platform_customer_fetch_params[:platform_customer_id])
    account_codes = platform_customer_fetch_params[:account_codes].present? ? platform_customer_fetch_params[:account_codes].split(",") : [platform_customer&.ar_account_code]
    FetchPlatformCustomersByAccountNumberJob.perform_now(current_user, current_user.current_project, account_codes) if account_codes.length.positive?
    redirect_to platform_account_customer_path(platform_customer_fetch_params[:platform_customer_id])
  end

  private

  def platform_customer_fetch_params
    params.require(:platform_customer_fetch).permit(:account_codes, :platform_customer_id)
  end

  def set_title
    @title = "Fetch Customers"
  end

  def customer_repo
    @customer_repo ||= PlatformAccountCustomerRepository.new(current_user)
  end
end

