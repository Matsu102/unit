class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :telephone_number, :user_type])
  end

  def is_locked_protect
    if user_signed_in? && current_user.is_locked == true
      if current_user.user_type == 'artist'
        redirect_to artist_path(current_user.id)
      else
        redirect_to fan_path(current_user.id)
      end
    end
  end

  #------------------------------ アクセス制限

  #----- admin
  # /admin/sign_in

  #----- users
  # homes          全て
  # /users/sign_up
  # /users/sign_in
  # arts           :index, :show
  # engagements    :index
  # helps          全て

  #------------------------------
end
