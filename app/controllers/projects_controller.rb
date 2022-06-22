class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[ show edit update ]
  before_action :set_title

  # GET /projects or /projects.json
  def index
    @query, page = ransack_query(Project, "name asc")

    @pagy, @projects = pagy(@query.result(distinct: true), page: page)
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new(active: true)
  end

  # GET /projects/1/edit
  def edit    
  end

 
  def create
    @project = repo.create(project_params)
    if @project.valid?
      redirect_to projects_path
    else
      render "new"
    end
  end

  def update
    @project = repo.update(params[:id], project_params)

    if @project.valid?
      redirect_to projects_path
    else
      render "edit"
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  def set_title
    @title = "Projects"
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:name, :active, :base_url, :pat_token, :auth_cookie, :expiry_minutes, :auth_cookie_updated_at, :version, :user_id, :sms_third_party_key, :email_third_party_key)
  end

  def repo
    @repo ||= ProjectRepository.new(current_user)
  end
end
