# frozen_string_literal: true

class ImportPlatformSchedulesJob < ApplicationJob
  discard_on StandardError # discard if fails
  queue_as :default

  def perform(user, project)
    PlatformScheduleAdapter.new(user, project).fetch
  end
end
