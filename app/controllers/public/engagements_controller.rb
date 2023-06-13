class Public::EngagementsController < ApplicationController

  def show
    @likes = Like.where(art_id: params[:art_id]).order(id: :desc)
    @comments = Comment.where(art_id: params[:art_id]).order(id: :desc)
    @art= Art.find(params[:art_id])
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.art_id = params[:art_id]
    if @comment.save
      redirect_to art_engagements_path(art_id: params[:art_id])
    else
      render :show
    end
  end

  def remove
    comment = Comment.find(params[:id])
    if comment.update(is_deleted: true)
      redirect_to art_engagements_path(art_id: params[:art_id])
    else
      render :show
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end
