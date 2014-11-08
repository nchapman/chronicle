class SavesController < ApplicationController
  before_action :set_save, only: [:show, :edit, :update, :destroy]
  before_action :require_user

  # TODO: There is probably some nice middle ground here
  skip_before_action :verify_authenticity_token

  # GET /saves
  # GET /saves.json
  def index
    @saves = current_user.saves.includes(:page).order('saves.created_at desc').page(params[:page])
  end

  # GET /saves/1
  # GET /saves/1.json
  def show
  end

  # GET /saves/exists.json?like[url]=http...
  # TODO: Do something for html requests?
  def exists
    render json: current_user.saves.find_by_url(save_params[:url]).exists?
  end

  # GET /saves/new
  def new
    @save = current_user.saves.new
  end

  # GET /saves/1/edit
  def edit
  end

  # POST /saves
  # POST /saves.json
  def create
    @save = current_user.saves.new(save_params)

    respond_to do |format|
      if @save.save
        format.html { redirect_to @save, notice: 'Save was successfully created.' }
        format.json { render :show, status: :created, location: @save }
      else
        format.html { render :new }
        format.json { render json: @save.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /saves/1
  # PATCH/PUT /saves/1.json
  def update
    respond_to do |format|
      if @save.update(save_params)
        format.html { redirect_to @save, notice: 'Save was successfully updated.' }
        format.json { render :show, status: :ok, location: @save }
      else
        format.html { render :edit }
        format.json { render json: @save.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /saves/1
  # DELETE /saves/1.json
  def destroy
    @save.destroy
    respond_to do |format|
      format.html { redirect_to saves_url, notice: 'Save was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # DELETE /saves?like[url]=http...
  # DELETE /saves.json {like: { url: ... }}
  def destroy_by_url
    @save = current_user.saves.find_by_url(save_params[:url]).first

    # Now that we have the right @like, destroy as usual
    destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_save
      @save = current_user.saves.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def save_params
      params.require(:save).permit(:url)
    end
end
