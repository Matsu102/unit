class Public::FollowsNoticesController < ApplicationController

  def index
    # binding.pry
    user = current_user
    # フォロー 一覧
    @my_follow = user.my_followers
    # フォロワー 一覧
    @my_follower = user.my_followeds
  end

end
