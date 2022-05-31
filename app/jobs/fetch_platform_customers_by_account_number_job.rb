class FetchPlatformCustomersByAccountNumberJob < ApplicationJob
  discard_on StandardError # discard if fails
  queue_as :default

  def perform(user, project, account_numbers)
    PlatformCustomerAdapter.new(user, project).fetch_by_account_number(account_numbers)
  end
end
