class Art < ApplicationRecord

  validates :image,  presence: true
  validates :title,  presence: true
  validates :detail, presence: true

  # 作品
  has_one_attached :image

  # User アソシエーション
  belongs_to :user

  # PostTag アソシエーション
  has_many :art_tags, dependent: :destroy # 投稿が削除された時に関連するタグを全て削除する
  has_many :tags, through: :art_tags

  # Comment アソシエーション
  has_many :comments, dependent: :destroy # 投稿が削除された時に関連するコメントを全て削除する

  # Like アソシエーション
  has_many :likes, dependent: :destroy # 投稿が削除された時に関連するいいねを全て

  # タグの保存と更新
  after_create do
    art = Art.find_by(id: id)
    tags = tagsbody.scan.split(",") # art_editのtagsbody内を読み込み、 "," 区切りで分ける
    tags.uniq.map do |tag|
      tag = Tag.find_or_create_by(tag: hashtag.downcase)
      art.tags << tag # Tagモデルのtagカラムに保存
    end
  end

  before_update do
    art = Art.find_by(id: id)
    art.tags.clear
    tags = tagsbody.scan.split(",")
    tags.uniq.map do |tag|
      tag = Tag.find_or_create_by(tag: hashtag.downcase)
      art.tags << tag # Tagモデルのtagカラムに保存
    end
  end

end
