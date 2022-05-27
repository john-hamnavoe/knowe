class Dashboard::LiftEvent::ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @activities = repo.all_group_by_month
  end

  private

  def repo
    @repo ||= PlatformLiftEventRepository.new(current_user)
  end
end
