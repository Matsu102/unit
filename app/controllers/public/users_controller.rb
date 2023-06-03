class Public::UsersController < ApplicationController

  def index
    @artists = User.where(user_type: "artist")
  end

  def artist
    @user = User.find(params[:id])
    if @user.user_type == "fan" # ファンのページは表示できないようにする
      redirect_to artists_path
    end
    @art = @user.arts
  end

  def fan
    @user = User.find(params[:id])
    if @user.user_type == "artist" # アーティストのページは表示できないようにする
      redirect_to artists_path
    end
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    @user.update(user_params)
    if @user.user_type == "artist"
      redirect_to artist_path(current_user.id)
    else
      redirect_to fan_path(current_user.id)
    end
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
