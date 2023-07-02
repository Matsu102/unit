class Tag < ApplicationRecord

  validates :name, presence: true, length: { in: 1..15 }

  # PostTag アソシエーション
  has_many :art_tags
  has_many :arts, through: :art_tags

end
