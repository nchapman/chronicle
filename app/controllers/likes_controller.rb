class LikesController < ApplicationController
  before_action :require_user

  def index
    @user_pages = likes_scope.includes(:page).page(params[:page])

    respond_with(@user_pages)
  end

  def show
    @user_page = likes_scope.find(params[:id])

    respond_with(@user_page)
  end

  def new
    @user_page = current_user.user_pages.new
  end

  def edit
    @user_page = likes_scope.find(params[:id])
  end

  def create
    @user_page = current_user.user_pages.new(new_like_params)
    @user_page.liked = true

    @user_page.save

    respond_with(@user_page)
  end

  def update
    @user_page = likes_scope.find(params[:id])

    @user_page.update(update_like_params)

    respond_with(@user_page)
  end

  def destroy
    # Find user page if it hasn't already been set
    @user_page ||= likes_scope.find(params[:id])

    @user_page.mark_unliked!

    respond_with(@user_page)
  end

  def exists
    render json: likes_scope.find_by_url(new_like_params[:url]).exists?
  end

  def destroy_by_url
    @user_page = likes_scope.find_by_url(new_like_params[:url]).first

    destroy
  end

  private

    def new_like_params
      params.require(:like).permit(:title, :description, :url)
    end

    def update_like_params
      params.require(:like).permit(:title, :description)
    end

    def likes_scope
      current_user.user_pages.likes
    end
end
