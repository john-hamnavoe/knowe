class Dashboard::Setting::CountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @count = repo.all.sum(:rows)
    @last_request = repo.all.maximum(:last_request)
  end

  private

  def repo
    @repo ||= PlatformSettingRepository.new(current_user)
  end
end
