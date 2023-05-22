class Tag < ApplicationRecord

  # PostTag アソシエーション
  has_many :post_tags
  has_many :posts, through: :post_tags

end
