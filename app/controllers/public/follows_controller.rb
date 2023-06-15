class Public::FollowsController < ApplicationController
  
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer # 遷移前のurlに飛ぶ
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer  
  end
  
end
