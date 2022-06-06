# frozen_string_literal: true

class ProjectRepository < ApplicationRepository
  def all(args, order_by, direction)
    query = Project.where(args)

    query.order(order_by => direction)
  end

  def create(params)
    project = Project.new(params)
    project.user = user
    project.save

    user.update(current_project: project) if user.current_project.nil?

    project
  end

  def update(id, params)
    project = Project.find_by(id: id)
    project&.update(params)
    project
  end

  def load(id)
    Project.find_by(id: id)
  end
end
