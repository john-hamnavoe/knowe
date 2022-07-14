# frozen_string_literal: true

class FetchAllPlatformCustomersJob < ApplicationJob
  discard_on StandardError # discard if fails
  queue_as :default

  def perform(user, project)
    PlatformCustomerAdapter.new(user, project).fetch_all
    PlatformCustomerSiteAdapter.new(user, project).fetch_all
    PlatformOrderAdapter.new(user, project).fetch_all
    PlatformContactAdapter.new(user, project).fetch_all
    PlatformContainerAdapter.new(user, project).fetch_all


    ActionCable.server.broadcast "ImportPlatformCustomersChannel", "all"       
  end

end