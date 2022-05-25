# frozen_string_literal: true

class SettingsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!

  def index
    redirect_to platform_settings_actions_path
  end

  private

  def repo
  end
end
