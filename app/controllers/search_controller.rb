class SearchController < ApplicationController
  before_action :require_user

  def index
    @user_pages = current_user.user_pages.search(params[:q]).records

    respond_with(@user_pages)
  end
end
