class Public::ArtistsController < ApplicationController

  def index
    @artists = User.where(user_type: "artist")
  end

  def show
    @artist = User.find(params[:id])
    if @artist.user_type == "fan" # ファンのページは表示できないようにする
      redirect_to artists_path
    end
  end

  private

end
