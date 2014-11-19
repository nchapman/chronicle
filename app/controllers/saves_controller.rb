class SavesController < ApplicationController
  before_action :require_user

  def index
    @user_pages = saves_scope.includes(:page).reorder('saved_at desc').page(params[:page])

    respond_with(@user_pages)
  end

  def show
    @user_page = saves_scope.find(params[:id])

    respond_with(@user_page)
  end

  def new
    @user_page = current_user.user_pages.new
  end

  def edit
    @user_page = saves_scope.find(params[:id])
  end

  def create
    @user_page = current_user.user_pages.find_or_create_by_url(new_save_params[:url])

    @user_page.update(new_save_params.merge({ saved: true }))

    respond_with(@user_page)
  end

  def update
    @user_page = saves_scope.find(params[:id])

    @user_page.update(update_save_params)

    respond_with(@user_page)
  end

  def destroy
    # Find user page if it hasn't already been set
    @user_page ||= saves_scope.find(params[:id])

    @user_page.mark_unsaved!

    respond_with(@user_page)
  end

  def exists
    render json: saves_scope.find_by_url(new_save_params[:url]).exists?
  end

  def destroy_by_url
    @user_page = saves_scope.find_by_url(new_save_params[:url]).first

    destroy
  end

  private

    def new_save_params
      @new_save_params ||= params.require(:save).permit(:title, :description, :read, :url)
    end

    def update_save_params
      params.require(:save).permit(:title, :description, :read)
    end

    def saves_scope
      current_user.user_pages.saves
    end
end
