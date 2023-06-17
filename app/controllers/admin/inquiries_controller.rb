class Admin::InquiriesController < ApplicationController
before_action :authenticate_admin!

  def show
    @inquiry = Inquiry.find(params[:id])
  end

  def update
    @inquiry = Inquiry.find(params[:id])
    @inquiry.update(inquiry_params)
    redirect_to admin_inquiry_path(@inquiry.id)
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:is_response)
  end

end
