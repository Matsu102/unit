class Public::HomesController < ApplicationController
before_action :is_locked_protect

  def top
    @arts = Art.includes(:user).where(users: {is_deleted: false, is_locked: false}).where(is_deleted: false).order(id: :desc)
  end

  def branch
  end

end
