class Admin::HomesController < ApplicationController
before_action :authenticate_admin!

  def top
    @inquiries = Inquiry.all.order(id: :desc).page(params[:page]).per(8)
  end
end
