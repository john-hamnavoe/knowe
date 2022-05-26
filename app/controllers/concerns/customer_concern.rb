# frozen_string_literal: true

module CustomerConcern
  extend ActiveSupport::Concern

  def set_customer
    @platform_customer_id = params[:platform_customer_id]
    @platform_customer = customer_repo.load(@platform_customer_id)
  end

  private

  def customer_repo
    PlatformCustomerRepository.new(current_user)
  end
end
