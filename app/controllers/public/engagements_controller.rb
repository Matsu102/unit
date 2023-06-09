class Public::EngagementsController < ApplicationController

  def show
    @likes = Like.where(art_id: params[:art_id])
    @comments = Comment.where(art_id: params[:art_id])
  end

end
