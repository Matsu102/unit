class Public::FollowsController < ApplicationController
before_action :authenticate_user!

  def create
    current_user.follow(params[:user_id])
    @user = User.find(params[:user_id])
    @user.create_notice_follow(current_user)
    redirect_to request.referer # 遷移前のurlに飛ぶ
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

end
