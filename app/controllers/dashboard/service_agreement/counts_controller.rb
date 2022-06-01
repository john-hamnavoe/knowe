class Dashboard::ServiceAgreement::CountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @count = repo.all.count
  end

  private

  def repo
    @repo ||= PlatformServiceAgreementRepository.new(current_user)
  end
end
