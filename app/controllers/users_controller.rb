class UsersController < ApplicationController
  def index
    @users = User.all

    respond_with(@users)
  end

  def show
    @user = User.find(params[:id])

    respond_with(@user)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    @user.save

    respond_with(@user)
  end

  def update
    @user = User.find(params[:id])

    @user.update(user_params)

    respond_with(@user)
  end

  def destroy
    @user = User.find(params[:id])

    @user.destroy

    respond_with(@user)
  end

  private

    def user_params
      params.require(:user).permit(:fxa_uid, :email, :name, :description, :oauth_token, :oauth_token_type)
    end
end
