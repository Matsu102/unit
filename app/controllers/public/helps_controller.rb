class Public::HelpsController < ApplicationController

  def index
  end

  def new
    @inquiry = Inquiry.new(inquiry_params)
    @inquiry.save
    redirect_to root_path
  end

  def confirm
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:last_name, :first_name, :member_id, :email, :inquiry_name, :inquiry_detail)
  end

end
