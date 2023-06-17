class Public::LikesController < ApplicationController
before_action :authenticate_user!

  def create
    art = Art.find(params[:art_id])
    like = current_user.likes.new(art_id: art.id)
    like.save
    #----- コメント機能
    like.create_notification_like(current_user)
    respond_to :js
    #----- コメント機能ここまで
    redirect_to art_path(art)
  end

  def destroy
    art = Art.find(params[:art_id])
    like = current_user.likes.find_by(art_id: art.id)
    like.destroy
    redirect_to art_path(art)
  end

end
