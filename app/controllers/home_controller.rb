class HomeController < ApplicationController
  def index
    redirect_to saves_path
  end
end
