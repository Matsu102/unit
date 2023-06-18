class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :telephone_number, :user_type])
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
