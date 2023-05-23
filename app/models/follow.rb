class Follow < ApplicationRecord

  # User アソシエーション
  belongs_to :follower, class_name: "User" # follower == Userモデルのid
  belongs_to :followed, class_name: "User" # followed == Userモデルのid

  # Notice アソシエーション
  has_many :notices

end
