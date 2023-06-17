class Public::FollowsController < ApplicationController
before_action :authenticate_user!

  def create
    current_user.follow(params[:user_id])
    @user.create_notices_follow(current_user)
    #----- コメント機能
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
    #-----コメント機能ここまで
    redirect_to request.referer # 遷移前のurlに飛ぶ
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

end
