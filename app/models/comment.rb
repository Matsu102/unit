class Comment < ApplicationRecord

  validates :body, presence: true, length: { in: 1..150 }

  # User アソシエーション
  belongs_to :user

  # Post アソシエーション
  belongs_to :art

  # Notice アソシエーション
  has_many :notices, dependent: :destroy

  # Comment アソシエーション
  has_many :replies, class_name: 'Comment', foreign_key: 'to_id', dependent: :destroy # has_many > Commentは複数の返信を持っている  class_name > モデル名

end