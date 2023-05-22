class Like < ApplicationRecord

  # User アソシエーション
  belongs_to :user

  # Post アソシエーション
  belongs_to :post

end
