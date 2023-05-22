class PostTag < ApplicationRecord

  # Post アソシエーション
  belongs_to :post
  # Tag アソシエーション
  belongs_to :tag

end
