class PagesController < ApplicationController
  def index
    @pages = current_user.pages.page(params[:page])

    respond_with(@pages)
  end

  def show
    @page = Page.find(params[:id])

    respond_with(@page)
  end

  def new
    @page = Page.new
  end

  def edit
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.create(page_params)

    respond_with(@page)
  end

  def update
    @page = Page.find(params[:id])

    @page.update(page_params)

    respond_with(@page)
  end

  def destroy
    @page = Page.find(params[:id])

    @page.destroy

    respond_with(@page)
  end

  private

    def page_params
      params.require(:page).permit(:url)
    end
end
