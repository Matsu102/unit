class Public::ArtsController < ApplicationController

  def index
    @arts = Art.all
  end

  def new
    @art = Art.new
  end

  def create
    @art = current_user.arts.build(art_params)
    if @art.save
      redirect_to art_path(@art)
    else
      render :new
    end
  end

  def show
    @art = Art.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def my_album
  end

  private

  def art_params
    params.require(:art).permit(:image, :title, :detail)
  end

end
