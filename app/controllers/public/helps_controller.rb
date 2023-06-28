class Public::HelpsController < ApplicationController

  def index
  end

  def new
    @inquiry = Inquiry.new
    @user = current_user
  end

  def confirm
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.invalid? # データが空でないかチェックする
      render :new
    end
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if params[:back] || !@inquiry.save # 戻るボタン 又は データが保存されなかった場合
      render :new and return
    end
    redirect_to root_path
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:last_name, :first_name, :member_id, :email, :inquiry_name, :inquiry_detail)
  end

end
