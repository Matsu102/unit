class Public::ArtsController < ApplicationController

  def index
    @arts = Art.all.order(id: :desc)
  end

  def search
    if params[:keyword] == "" # 検索ワードが空欄の場合はarts_pathを再読み込み
      redirect_to arts_path
    else
      split_keyword = params[:keyword].split(/[[:blank:]]+/) # スペースで区切られたkeywordを個別のデータとして扱う
      @arts = []
      split_keyword.each do |keyword| # split_keywordに格納されたワードを一つずつ取り出して検索
        next if keyword == ""
        @arts += Art.order(id: :desc).where(["title like?", "%#{keyword}%",]) # Artのtitleカラムと照合
        @arts += Art.joins(:tags).order(id: :desc).where(["name like?", "%#{keyword}%"]) # Artに紐づいているTagのnameカラムと照合
      end
      @arts.uniq! #重複した作品を除外する
      @search_word = split_keyword.join("　") # keywordを全角スペースで区切って結合
      render :index
    end
  end

  def artist_arts
    @user = User.find(params[:id])
    @arts = Art.where(user_id: @user.id).order(id: :desc)
  end

  def new
    @art = Art.new
  end

  def create
    @art = current_user.arts.new(art_params)
    if @art.save
      tag_names = params[:art][:tagsbody].split(",")
      @art.tags_save(tag_names)
      redirect_to art_path(@art.id)
    else
      render :new
    end
  end

  def show
    @art = Art.find(params[:id])
    @tags = @art.tags
    @comments = Comment.where(art_id: @art.id, to_id: nil) # 親コメント
  end

  def hashtag
    @arts = Art.joins(:tags).where(tags: { name: params[:tag]} ).distinct
    @search_word = "#" + params[:tag]
    render :index
  end

  def view
    @art = Art.find(params[:id])
  end

  def edit
    @art = Art.find(params[:id])
    @art.tagsbody = @art.tags.pluck(:name).join(',')
  end

  def update
    @art = Art.find(params[:id])
    if @art.update(art_params)
      tag_names = params[:art][:tagsbody].split(",")
      @art.tags_save(tag_names)
      redirect_to art_path(@art.id)
    else
      render :edit
    end
  end

  def destroy
    @art = Art.find(params[:id])
    @art.user_id = current_user.id
    @art.destroy
    flash[:notice] = "投稿を削除しました。"
    redirect_to artist_path(current_user.id)
  end

  def my_album
  end

  private

  def art_params
    params.require(:art).permit(:image, :title, :detail, :tagsbody)
  end

end
