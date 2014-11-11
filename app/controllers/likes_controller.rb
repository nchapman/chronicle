class LikesController < ApplicationController
  before_action :set_like, only: [:show, :edit, :update, :destroy]
  before_action :require_user

  # TODO: There is probably some nice middle ground here
  skip_before_action :verify_authenticity_token

  # GET /likes
  # GET /likes.json
  def index
    @likes = current_user.user_pages.likes.includes(:page).page(params[:page])
  end

  # GET /likes/1
  # GET /likes/1.json
  def show
  end

  # GET /likes/exists.json?like[url]=http...
  # TODO: Do something for html requests?
  def exists
    render json: current_user.user_pages.likes.find_by_url(like_params[:url]).exists?
  end

  # GET /likes/new
  def new
    @like = current_user.user_pages.new
  end

  # GET /likes/1/edit
  def edit
  end

  # POST /likes
  # POST /likes.json
  def create
    @like = current_user.user_pages.new(like_params)
    @like.liked = true

    respond_to do |format|
      if @like.save
        format.html { redirect_to @like, notice: 'Like was successfully created.' }
        format.json { render :show, status: :created, location: @like }
      else
        format.html { render :new }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /likes/1
  # PATCH/PUT /likes/1.json
  def update
    respond_to do |format|
      if @like.update(like_params)
        format.html { redirect_to @like, notice: 'Like was successfully updated.' }
        format.json { render :show, status: :ok, location: @like }
      else
        format.html { render :edit }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1
  # DELETE /likes/1.json
  def destroy
    @like.mark_unliked!

    respond_to do |format|
      format.html { redirect_to likes_url, notice: 'Like was successfully removed.' }
      format.json { head :no_content }
    end
  end

  # DELETE /likes?like[url]=http...
  # DELETE /likes.json {like: { url: ... }}
  def destroy_by_url
    @like = current_user.likes.find_by_url(like_params[:url]).first

    # Now that we have the right @like, destroy as usual
    destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = current_user.user_pages.likes.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def like_params
      params.require(:like).permit(:title, :description, :url)
    end
end
