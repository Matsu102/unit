class Public::LikesController < ApplicationController
before_action :authenticate_user!

  def create
    art = Art.find(params[:art_id])
    like = current_user.likes.new(art_id: art.id)
    like.save
    art.create_notice_like(current_user)
    redirect_to art_path(art)
  end

  def destroy
    art = Art.find(params[:art_id])
    like = current_user.likes.find_by(art_id: art.id)
    like.destroy
    redirect_to art_path(art)
  end

end