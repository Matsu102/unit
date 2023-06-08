class Art < ApplicationRecord

  validates :image,  presence: true
  validates :title,  presence: true
  validates :detail, presence: true

  # 作品
  has_one_attached :image

  # User アソシエーション
  belongs_to :user

  # ArtTag アソシエーション
  has_many :art_tags, dependent: :destroy # 投稿が削除された時に関連するタグを全て削除する
  has_many :tags, through: :art_tags

  # Comment アソシエーション
  has_many :comments, dependent: :destroy # 投稿が削除された時に関連するコメントを全て削除する

  # Like アソシエーション
  has_many :likes, dependent: :destroy # 投稿が削除された時に関連するいいねを全て

  # タグの保存と更新
  def tags_save(tag_names)
    tag_names.each do |tag_name|
      # Todo: 既存のタグは保存しない
      # Todo: 更新時にart_tagsの紐付けを外す
      tag = Tag.new(tag: tag_name)
      tag.save
      art_tag = tag.art_tags.new(art_id: id)
      art_tag.save
    end
  end

end
