class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @connected = false
    return if current_user.current_project.nil?

    platform_client = PlatformClient.new(current_user.current_project)
    auth_cookie = platform_client.pat_login
    @connected = auth_cookie.present?
  end
end
