class Public::ArtsController < ApplicationController
before_action :authenticate_user!, except: [:index, :show]
before_action :is_locked_protect

  def index
    @arts = Art.includes(:user).where(users: {is_deleted: false, is_locked: false}).order(id: :desc).page(params[:page]).per(10)
  end

  def search
    if params[:keyword] == "" # 検索ワードが空欄の場合はarts_pathを再読み込み
      redirect_to arts_path
    else
      split_keyword = params[:keyword].split(/[[:blank:]]+/) # スペースで区切られたkeywordを個別のデータとして扱う
      @arts = []
      split_keyword.each do |keyword| # split_keywordに格納されたワードを一つずつ取り出して検索
        next if keyword == ""
        @arts += Art.order(id: :desc).includes(:user).where(users: {is_deleted: false, is_locked: false}).where(["title like?", "%#{keyword}%",]) # Artのtitleカラムと照合
        @arts += Art.joins(:tags).order(id: :desc).where(["name like?", "%#{keyword}%"]) # Artに紐づいているTagのnameカラムと照合
      end
      @arts.uniq! #重複した作品を除外する
      @arts = Kaminari.paginate_array(@arts).page(params[:page]).per(10)
      @search_word = split_keyword.join("　") # keywordを全角スペースで区切って結合
      render :index
    end
  end

  def my_album
    users = current_user.my_followers # users > フォローしているユーザの情報をusersに格納
    @arts = Art.includes(:user).where(users: {is_deleted: false, is_locked: false}).where(user_id: users.map(&:id)).order(id: :desc).page(params[:page]).per(10) # map > カラムを指定してデータを取り出す  serts.id でも取れそうな雰囲気だが、エラーが出る。 (User.all.idと書いているようなもの)
  end

  def artist_arts
    @user = User.find(params[:id])
    @arts = Art.where(user_id: @user.id).order(id: :desc).page(params[:page]).per(10)
    if (@user.is_deleted == true) or (@user.is_locked == true)
      flash[:alert] = '不正なエラー'
      redirect_to arts_path
    end
  end

  def new
    @art = Art.new
    if (current_user.is_deleted == true) or (current_user.is_locked == true)
      flash[:alert] = '不正なエラー'
      redirect_to artist_path
    end
  end

  def create
    @art = current_user.arts.new(art_params)
    if @art.save
      tag_names = params[:art][:tagsbody].split(',')
      if !tag_names.any? { |name| name.length > 15 }
        @art.tags_save(tag_names)
        flash[:notice] = '投稿しました。'
        redirect_to art_path(@art.id)
      else
        flash[:alert] = 'タグは1つ15文字以内で記入してください。'
        render :new
      end
    else
      tag_names = params[:art][:tagsbody].split(',')
      unless !tag_names.any? { |name| name.length > 15 }
        flash[:alert] = 'タグは1つ15文字以内で記入してください。'
      end
      render :new
    end
  end

  def show
    @art = Art.find(params[:id])
    if (@art.user.is_deleted == true) or (@art.user.is_locked == true)
      flash[:alert] = '不正なエラー'
      redirect_to arts_path
    end
    @tags = @art.tags
    @comments = Comment.where(art_id: @art.id, to_id: nil, is_deleted: false) # 親コメント
  end

  def hashtag
    @arts = Art.joins(:tags).includes(:user).where(users: {is_deleted: false, is_locked: false}).where(tags: { name: params[:tag]} ).distinct.page(params[:page]).per(12)
    @search_word = '#' + params[:tag]
    render :index
  end

  def view
    @art = Art.find(params[:id])
    if (@art.user.is_deleted == true) or (@art.user.is_locked == true)
      flash[:alert] = '不正なエラー'
      redirect_to arts_path
    end
  end

  def edit
    @art = Art.find(params[:id])
    @art.tagsbody = @art.tags.pluck(:name).join(',')
    if @art.user.id != current_user.id
      flash[:alert] = '不正なエラー'
      redirect_to arts_path
    end
    if (@art.user.is_deleted == true) or (@art.user.is_locked == true)
      flash[:alert] = '不正なエラー'
      redirect_to artist_path
    end
  end

  def update
    @art = Art.find(params[:id])
    if @art.user_id != current_user.id
      flash[:alert] = '不正なエラー'
      redirect_to arts_path
    elsif @art.update(art_params)
      tag_names = params[:art][:tagsbody].split(',')
      if !tag_names.any? { |name| name.length > 15 }
        @art.tags_save(tag_names)
        flash[:notice] = '投稿を更新しました。'
        redirect_to art_path(@art.id)
      else
        flash[:alert] = 'タグは1つ15文字以内で記入してください。'
        render :edit
      end
    else
      tag_names = params[:art][:tagsbody].split(',')
      unless !tag_names.any? { |name| name.length > 15 }
        flash[:alert] = 'タグは1つ15文字以内で記入してください。'
      end
      render :edit
    end
  end

  def remove
    @art = Art.find(params[:id])
    if @art.user_id != current_user.id
      flash[:alert] = '不正なエラー'
      redirect_to arts_path
    else
      @art.update(is_deleted: true)
      flash[:notice] = '投稿を削除しました。'
      redirect_to artist_path(current_user.id)
    end
  end

  private

  def art_params
    params.require(:art).permit(:image, :title, :detail, :tagsbody)
  end

end
