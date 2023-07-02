class Follow < ApplicationRecord

  validates :follower_id, presence: true, numericality: { only_integer: true }
  validates :followed_id, presence: true, numericality: { only_integer: true }

  # フォロー数制限
  validates_uniqueness_of :follower_id, scope: :followed_id


  # User アソシエーション
  belongs_to :follower, class_name: 'User' # follower == Userモデルのid
  belongs_to :followed, class_name: 'User' # followed == Userモデルのid

end
