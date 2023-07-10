class Public::UsersController < ApplicationController
before_action :authenticate_user!
before_action :is_locked_protect, only: [:index, :edit]

  def index
    @user = User.where(user_type: 'artist', is_deleted: false, is_locked: false).page(params[:page]).per(12) # insexにはアーティストのみ表示
  end

  def search
    if params[:keyword] == "" # 検索ワードが空欄の場合はartists_pathを再読み込み
      redirect_to artists_path
    else
      @user = User.where(["handle_name like?", "%#{params[:keyword]}%"]).where(user_type: 'artist', is_deleted: false, is_locked: false).page(params[:page]).per(12)
      @search_word = params[:keyword]
      render :index
    end
  end

  def artist
    @user = User.find(params[:id])
    if (@user.id == current_user.id) and (@user.is_locked == true)
    elsif (@user.user_type == 'fan') or (@user.is_deleted == true) or (@user.is_locked == true) # ファン、退会済み、凍結中ユーザのページは表示できないようにする
      redirect_to artists_path
    end
    @arts = Art.where(user_id: @user.id, is_deleted: false).order(id: :desc)
  end

  def fan
    @user = User.find(params[:id])
    if (@user.id == current_user.id) and (@user.is_locked == true)
    elsif (@user.user_type == 'artist') or (@user.is_deleted == true) or (@user.is_locked == true) # アーティスト、退会済み、凍結中ユーザのページは表示できないようにする
      redirect_to artists_path
    end
  end

  def edit
    @user = User.find(current_user.id)
    if @user.is_locked == true
      redirect_to artists_path
    end
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      if @user.user_type == 'artist'
        flash[:notice] = '登録情報を更新しました。'
        redirect_to artist_path(current_user.id)
      else
        flash[:notice] = '登録情報を更新しました。'
        redirect_to fan_path(current_user.id)
      end
    else
      render :edit
    end
  end

  def confirm
    @user = User.find(current_user.id)
    if @user.is_locked == true
      redirect_to artists_path
    end
  end

  def withdraw
    @user = User.find(current_user.id)
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = '退会が完了しました。またのご利用をお待ちしております。'
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :handle_name, :email, :telephone_number, :url, :introduction, :user_type, :is_deleted, :thumbnail)
  end

end
