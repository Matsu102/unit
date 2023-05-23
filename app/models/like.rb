class Like < ApplicationRecord

  # User アソシエーション
  belongs_to :user

  # Post アソシエーション
  belongs_to :post

  # Notice アソシエーション
  has_many :notices

end
