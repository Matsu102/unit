class Public::FollowsNoticesController < ApplicationController
before_action :authenticate_user!

  def index
    user = current_user
    #-----フォロー機能
    @my_followers = user.my_followers   # フォロー 一覧
    @my_followeds = user.my_followeds # フォロワー 一覧
    #-----通知機能
    notices = current_user.passive_notices
    @notice = notices.where.not(visitor_id: current_user.id)
  end

  def update
    @notice = Notice.find(params[:id])
    @notice.update(notice_params)
    redirect_to follows_notices_path
  end

  def update_all
    notices = current_user.passive_notices
    @notice = notices.where.not(visitor_id: current_user.id)
    @notice.update(notice_params)
    redirect_to follows_notices_path
  end

  def notice_params
    params.require(:notice).permit(:checked)
  end

end