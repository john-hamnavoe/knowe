# frozen_string_literal: true

module CustomerConcern
  extend ActiveSupport::Concern

  def set_customer
    @platform_customer_id = params[:platform_account_customer_id] || params[:platform_casual_customer_id]
    @platform_customer = customer_repo.load(@platform_customer_id)
  end

  def customer_repo
    @customer_repo ||= PlatformCustomerRepository.new(current_user)
  end
end
