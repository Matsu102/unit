class Public::EngagementsController < ApplicationController
before_action :authenticate_user!, except: [:show]
before_action :is_locked_protect

  def show
    @likes = Like.where(art_id: params[:art_id]).order(id: :desc)
    @comments = Comment.where(art_id: params[:art_id], to_id: nil, is_deleted: false).order(id: :desc) # 親コメント
    @art= Art.find(params[:art_id])
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.art_id = params[:art_id]
    if @comment.body.length == 0
      if @comment.to_id == nil
        flash[:alert] = 'コメントが入力されていません。'
      else
        flash[:alert] = '返信が入力されていません。'
      end
    elsif @comment.body.length > 150
      if @comment.to_id == nil
        flash[:alert] = 'コメントは150字までです。'
      else
        flash[:alert] = '返信は150字までです。'
      end
    else
      @comment.save
      @comment.art.create_notice_comment(current_user, @comment.id)
      if @comment.to_id == nil
        flash[:notice] = 'コメントしました。'
      else
        flash[:notice] = '返信しました。'
      end
    end
    redirect_to art_engagements_path(art_id: params[:art_id])
  end

  def remove
    comment = Comment.find(params[:id])
    if comment.user_id != current_user.id
      flash[:alert] = '不正なエラー'
      render :show
    else
      comment.update(is_deleted: true)
      if comment.to_id == nil
        flash[:notice] = 'コメントを削除しました。'
      else
        flash[:notice] = '返信を削除しました。'
      end
      redirect_to art_engagements_path(art_id: params[:art_id])
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :to_id)
  end

end
