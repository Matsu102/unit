class Like < ApplicationRecord

  # いいね数制限
  validates_uniqueness_of :art_id, scope: :user_id

  # User アソシエーション
  belongs_to :user

  # Post アソシエーション
  belongs_to :art

end
