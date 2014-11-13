class VisitsController < ApplicationController
  before_action :require_user

  def index
    @visits = current_user.visits.includes(:page).order('visits.created_at desc').page(params[:page])

    respond_with(@visits)
  end

  def show
    @visit = current_user.visits.find(params[:id])

    respond_with(@visit)
  end

  def new
    @visit = current_user.visits.new

    respond_with(@visit)
  end

  def edit
    @visit = current_user.visits.find(params[:id])
  end

  def create
    @visit = current_user.visits.new(visit_params)

    @visit.save

    respond_with(@visit)
  end

  def update
    @visit = current_user.visits.find(params[:id])

    @visit.update(visit_params)

    respond_with(@visit)
  end

  def destroy
    @visit = current_user.visits.find(params[:id])

    @visit.destroy

    respond_with(@visit)
  end

  private

    def visit_params
      params.require(:visit).permit(:url)
    end
end
