class SearchController < ApplicationController
  def index
    @user_pages = UserPage.search(params[:q]).records

    respond_with(@user_pages)
  end
end
