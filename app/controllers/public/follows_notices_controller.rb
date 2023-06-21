class Public::FollowsNoticesController < ApplicationController
before_action :authenticate_user!

  def index
    user = current_user
    #-----フォロー機能
    @my_follow = user.my_followers   # フォロー 一覧
    @my_follower = user.my_followeds # フォロワー 一覧
    #-----通知機能
    @notice = Notice.where.not(visitor_id: current_user.id)
    @notices = current_user.passive_notices
    @notices.where(checked: false).each do |notice|
      notice.update_attribute(:checked, true)
    end
  end

  def update
    @notice = Notice.where.not(visitor_id: current_user.id)
    @notice.update(notice_params)
    redirect_to follows_notices_path
  end

  def notice_params
    params.require(:notice).permit(:checked)
  end

end