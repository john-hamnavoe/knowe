# frozen_string_literal: true

class FetchPlatformCustomersByAccountNumberJob < ApplicationJob
  discard_on StandardError # discard if fails
  queue_as :default

  def perform(user, project, account_numbers)
    PlatformAccountCustomerAdapter.new(user, project).fetch_by_account_number(account_numbers)

    ActionCable.server.broadcast "ImportPlatformCustomersChannel", account_numbers.join(" ")    
  end
end
