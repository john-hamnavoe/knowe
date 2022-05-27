class Dashboard::LiftEvent::CountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @count = repo.all.count
  end

  private

  def repo
    @repo ||= PlatformLiftEventRepository.new(current_user)
  end
end
