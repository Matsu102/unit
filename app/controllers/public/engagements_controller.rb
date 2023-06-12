class Public::EngagementsController < ApplicationController

  def show
    @likes = Like.where(art_id: params[:art_id])
    @comments = Comment.where(art_id: params[:art_id])
  end

  def create
    @comment = Comment.new
  end

  def remove

  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
