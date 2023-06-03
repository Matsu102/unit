class Tag < ApplicationRecord

  # PostTag アソシエーション
  has_many :art_tags, dependent: :destroy # 投稿が削除された時に関連するタグを全て削除する
  has_many :arts, through: :art_tags

end
