class Public::ArtistsController < ApplicationController

  def index
    @artists = User.where(user_type: "artist")
  end

  def show
  end
end
