class Like < ApplicationRecord

  validates :art_id,  presence: true, numericality: { only_integer: true }
  validates :user_id, presence: true, numericality: { only_integer: true }

  # いいね数制限
  validates_uniqueness_of :art_id, scope: :user_id

  # User アソシエーション
  belongs_to :user

  # Post アソシエーション
  belongs_to :art

end
