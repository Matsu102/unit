class Post < ApplicationRecord

  # User アソシエーション
  belongs_to :user

  # PostTag アソシエーション
  has_many :post_tags, dependent: :destroy # 投稿が削除された時に関連するタグを全て削除する
  has_many :tags, through: :post_tags
  
  # Comment アソシエーション
  has_many :comments, dependent: :destroy # 投稿が削除された時に関連するコメントを全て削除する
  
  # Like アソシエーション
  has_many :likes, dependent: :destroy # 投稿が削除された時に関連するいいねを全て

end
