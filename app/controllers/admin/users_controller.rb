class Admin::UsersController < ApplicationController

  def index
    @users = User.all
  end

  def search
    if params[:keyword_id] == "" &&         # 検索ワードが全て空欄の場合はadmin_users_pathを再読み込み
       params[:keyword_last_name] == "" &&
       params[:keyword_first_name] == "" &&
       params[:keyword_handle_name] == ""
      redirect_to admin_users_path
    else
      @users = User.order(id: :desc).where(["id LIKE(?) AND last_name LIKE(?) AND first_name LIKE(?) AND handle_name LIKE(?)", "%#{params[:keyword_id]}%", "%#{params[:keyword_last_name]}%", "%#{params[:keyword_first_name]}%", "%#{params[:keyword_handle_name]}%"])
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
    @user.update(user_params)
    redirect_to admin_user_path
  end

  private

  def user_params
    params.require(:user).permit(:is_locked)
  end

end
