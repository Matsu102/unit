class Public::LikesController < ApplicationController

  def create
    art = Art.find(params[:art_id])
    like = current_user.likes.new(art_id: art.id)
    like.save
    redirect_to art_path(art)
  end

  def destroy
    art = Art.find(params[:art_id])
    like = current_user.likes.find_by(art_id: art.id)
    like.destroy
    redirect_to art_path(art)
  end

end
