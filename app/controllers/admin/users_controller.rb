class Admin::UsersController < ApplicationController

  def index
    if params[:keyword]
      @users = User.where(:keyword)
    else
      @users = User.all
    end
  end

  def search
    if params[:keyword] == ""
      redirect_to admin_users_path
    else
      split_keyword = params[:keyword].split(/[[:blank:]]+/).select(&:present?)
      @users = []
      split_keyword.each do |keyword|
        next if keyword == ""
        @users += User.where(["id like? or last_name like? or first_name like? or handle_name like?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%"])
      end
      @users.uniq! #重複したユーザを除外する
      render :index
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to admin_user_path
  end

  private

  def user_params
    params.require(:user).permit(:is_locked)
  end

end
