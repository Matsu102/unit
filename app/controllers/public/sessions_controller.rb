# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController

  before_action :user_state, only: [:create]

  def after_sign_in_path_for(resource)
    if current_user.user_type == 'artist'
      artist_path(current_user.id)
    elsif (current_user.user_type == 'fan') && (current_user.is_locked == true)
      fan_path(current_user.id)
    else
      my_album_path
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end


  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  #

  protected

  def user_state
    @user = User.find_by(email: params[:user][:email])
    return if !@user
    if @user.valid_password?(params[:user][:password]) && (@user.is_deleted == true)
      flash[:notice] = '退会済みです。再度ご登録ください。'
      redirect_to branch_path
    end
  end

end
