class Comment < ApplicationRecord

  validates :body, presence: true, length: { in: 1..150 }

  # User アソシエーション
  belongs_to :user

  # Post アソシエーション
  belongs_to :art

  # Notice アソシエーション
  has_many :notices

end