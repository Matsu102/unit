class Public::UsersController < ApplicationController

  def show
    @user = User.find(current_user.id)
    @post = @user.posts
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    @user.update(user_params)
    redirect_to my_page_path
  end

  def confirm
    @user = User.find(current_user.id)
  end

  def withdraw
    @user = User.find(current_user.id)
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会が完了しました。またのご利用をお待ちしております。"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :handle_name, :email, :telephone_number, :url, :introduction, :user_type, :is_deleted, :thumbnail)
  end

end
