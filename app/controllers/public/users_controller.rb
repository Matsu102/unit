class Public::UsersController < ApplicationController

  def show
    @user = User.find(current_user.id)
    @post = @user.posts
  end

  def edit
  end

  def confirm
  end
end
