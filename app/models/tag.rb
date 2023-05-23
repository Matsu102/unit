class Tag < ApplicationRecord

  # PostTag アソシエーション
  has_many :post_tags, dependent: :destroy # 投稿が削除された時に関連するタグを全て削除する
  has_many :posts, through: :post_tags

end
