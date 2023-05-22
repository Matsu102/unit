class Follow < ApplicationRecord

  belongs_to :follower, class_name: "User" # follower == Userモデルのid
  belongs_to :followed, class_name: "User" # followed == Userモデルのid

end
