# frozen_string_literal: true

class ImportPlatformSettingsJob < ApplicationJob
  discard_on StandardError # second catch other exceptions
  queue_as :default

  def perform(user, project)
    settings = PlatformSettingRepository.new(user, project).all
    settings.each do |setting|
      "#{setting.class_name}Adapter".constantize.new(user, project).fetch
    end
  end
end
