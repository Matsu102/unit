class Public::ArtsController < ApplicationController

  def index
    @arts = Art.all
  end

  def artist_arts
    @user = User.find(params[:id])
    @arts = Art.where(user_id: @user.id)
  end

  def new
    @art = Art.new
  end

  def create
    @art = current_user.arts.build(art_params)
    if @art.save
      redirect_to art_path(@art.id)
    else
      render :new
    end
  end

  def show
    @art = Art.find(params[:id])
  end

  def view
    @art = Art.find(params[:id])
  end

  def edit
    @art = Art.find(params[:id])
  end

  def update
    @art = Art.find(params[:id])
    if @art.update(art_params)
      redirect_to art_path(@art.id)
    else
      render :edit
    end
  end

  def destroy
    @art = Art.find(params[:id])
    @art.user_id = current_user.id
    @art.destroy
    flash[:notice] = "投稿を削除しました。"
    redirect_to artist_path(current_user.id)
  end

  def my_album
  end

  private

  def art_params
    params.require(:art).permit(:image, :title, :detail)
  end

end
