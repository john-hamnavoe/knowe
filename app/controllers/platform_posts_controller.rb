class PlatformPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformPost, "position asc")

    @pagy, @platform_posts = pagy(@query.result(distinct: true), page: page)
  end

  def post_to_platform
    platform_post = repo.load(params[:id])

    PostNewLiftEventsJob.perform_later(current_user, current_user.current_project) if platform_post.class_name == "PlatformLiftEvent"

    redirect_to platform_posts_path
  end

  private

  def set_title
    @title = "Items to Post to Platform"
  end

  def repo
    @repo ||= PlatformPostRepository.new(current_user)
  end
end
