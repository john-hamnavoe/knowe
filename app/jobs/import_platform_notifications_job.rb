# frozen_string_literal: true

class ImportPlatformNotificationsJob < ApplicationJob
  discard_on StandardError # second catch other exceptions
  queue_as :default

  def perform(user, project)
    PlatformNotificationAdapter.new(user, project).fetch
  end
end
