# frozen_string_literal: true

if ENV["RAILS_ENV"] == "test"
  require "simplecov"
  SimpleCov.start "rails" do
    add_filter "/bin/"
    add_filter do |source_file|
      source_file.lines.count < 5
    end
  end
  Rails.logger.debug "required simplecov from initializer"
end
