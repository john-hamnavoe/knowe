class Dashboard::Customer::CountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @count = repo.all.count
  end

  private

  def repo
    @repo ||= PlatformCustomerRepository.new(current_user)
  end
end
