class Admin::UsersController < ApplicationController
before_action :authenticate_admin!

  def index
    @users = User.all.page(params[:page]).per(12)
  end

  def search
    if params[:keyword_id] == "" &&         # 検索ワードが全て空欄の場合はadmin_users_pathを再読み込み
       params[:keyword_last_name] == "" &&
       params[:keyword_first_name] == "" &&
       params[:keyword_handle_name] == ""
      redirect_to admin_users_path
    else
      @users = User.where(["id LIKE(?) AND last_name LIKE(?) AND first_name LIKE(?) AND handle_name LIKE(?)", "%#{params[:keyword_id]}%", "%#{params[:keyword_last_name]}%", "%#{params[:keyword_first_name]}%", "%#{params[:keyword_handle_name]}%"]).page(params[:page]).per(12)
      @search_words = params[:keyword_id] + params[:keyword_last_name] + params[:keyword_first_name] + params[:keyword_handle_name]
      @search_word_id = params[:keyword_id]
      @search_word_last_name = params[:keyword_last_name]
      @search_word_first_name = params[:keyword_first_name]
      @search_word_handle_name = params[:keyword_handle_name]
      render :index
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:back]
    elsif @user.update!(user_params) # !を付けるとエラーが出た際にエラーメッセージが表示される
      flash[:notice] = '変更しました。'
      redirect_to admin_users_path
    else
      flash[:alert] = '不正なエラー'
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:is_locked)
  end

end
