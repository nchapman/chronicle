class UserPagesController < ApplicationController
  before_action :require_user

  def index
    @user_pages = current_user.user_pages.all

    respond_with(@user_pages)
  end
end
