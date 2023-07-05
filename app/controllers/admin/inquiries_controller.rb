class Admin::InquiriesController < ApplicationController
before_action :authenticate_admin!

  def show
    @inquiry = Inquiry.find(params[:id])
  end

  def update
    @inquiry = Inquiry.find(params[:id])
    if @inquiry.update(inquiry_params)
      flash[:notice] = '変更しました。'
      redirect_to admin_root_path
    else
      flash[:alert] = '不正なエラー'
      render :show
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:is_response)
  end

end
