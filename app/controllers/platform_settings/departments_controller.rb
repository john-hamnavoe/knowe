# frozen_string_literal: true

class PlatformSettings::DepartmentsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformDepartment, "description asc")

    @pagy, @platform_departments = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformDepartmentRepository.new(current_user)
  end

  def set_title
    @title = "Departments"
  end
end
