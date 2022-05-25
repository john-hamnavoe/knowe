# frozen_string_literal: true

class PlatformSettings::DepartmentsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_departments_from_platform

  def index
    @query, page = ransack_query(PlatformDepartment, "description asc")

    @pagy, @platform_departments = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_departments_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "Departments are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformDepartmentRepository.new(current_user)
  end

  def set_title
    @title = "Departments"
  end
end
