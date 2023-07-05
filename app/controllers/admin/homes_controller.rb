class Admin::HomesController < ApplicationController
before_action :authenticate_admin!

  def top
    @inquiries = Inquiry.all.page(params[:page]).per(8)
  end
end
