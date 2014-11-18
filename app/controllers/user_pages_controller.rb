class UserPagesController < ApplicationController
  before_action :require_user

  def index
    @user_pages = current_user.user_pages.all

    respond_with(@user_pages)
  end

  def update
    @user_page = current_user.user_pages.find(params[:id])

    @user_page.update(user_page_params)

    respond_with(@user_page)
  end

  private

    def user_page_params
      params.require(:user_page).permit(:saved, :liked, :archived)
    end
end
