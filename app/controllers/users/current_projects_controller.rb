# frozen_string_literal: true

class Users::CurrentProjectsController < ApplicationController
  before_action :authenticate_user!

  def update
    project = repo.load(params[:id])
    current_user.update current_project: project if project
    redirect_to root_path
    # redirect to differnt page in here causes env["warden"].user to be wrong value in action cable connection. Need to investigate why.
  end

  protected

  def repo
    @repo ||= ProjectRepository.new(current_user)
  end
end
