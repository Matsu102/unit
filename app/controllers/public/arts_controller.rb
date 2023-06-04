class Public::ArtsController < ApplicationController

  def index
    @arts = Art.all
  end

  def artist_arts
    @arts = Art.where(user_id: :id)
    @user = User.find(params[:id])
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
    @art = Art.find(params[:id])
  end

  def update
    @art = Art.find(params[:id])
    if @user.update(art_params)
      redirect_to art_path(params[:id])
    else
      render :edit
    end
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
