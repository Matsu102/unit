class Public::HomesController < ApplicationController
before_action :is_locked_protect

  def top
    @arts = Art.all.order(id: :desc)
  end

  def branch
  end

end
