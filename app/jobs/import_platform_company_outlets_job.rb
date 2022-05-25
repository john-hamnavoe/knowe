# frozen_string_literal: true

class ImportPlatformCompanyOutletsJob < ApplicationJob
  discard_on StandardError # second catch other exceptions
  queue_as :default

  def perform(user, project)
    PlatformCompanyOutletAdapter.new(user, project).fetch
  end
end
