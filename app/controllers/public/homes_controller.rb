class Public::HomesController < ApplicationController

  def top
    @arts = Art.all.order(id: :desc)
  end

  def branch
  end

end
