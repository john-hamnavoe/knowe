# frozen_string_literal: true

class ApplicationRepository
  attr_accessor :project, :user

  def initialize(user, project = nil)
    @project = project || user.current_project
    @user = user
  end
end
