class Public::FollowsNoticesController < ApplicationController
before_action :authenticate_user!

  def index
    #-----フォロー機能
    user = current_user
    @my_follow = user.my_followers   # フォロー 一覧
    @my_follower = user.my_followeds # フォロワー 一覧
    #-----通知機能
    @notices = current_user.passive_notices
    @notices.where(checked: false).each do |notification|
      notices.update_attributes(checked: true)
    end
  end

end