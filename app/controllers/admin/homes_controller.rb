class Admin::HomesController < ApplicationController
  
  def top
    @inquiries = Inquiry.all
  end
end
