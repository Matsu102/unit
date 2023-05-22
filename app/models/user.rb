class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :followers, class_name: "Follow", foreign_key: "follower_id" # followers == Followモデルのfollower_id == フォローしたユーザのid == current_userがフォローしているユーザ
  has_many :followeds, class_name: "Follow", foreign_key: "followed_id" # followeds == Followモデルのfollowed_id == フォローされたユーザのid == current_userをフォローしているユーザ

  has_many :followings, through: :followers, source: :followed # ユーザのフォローリストで表示   中間テーブル経由でcurrent_userがフォローしたユーザ情報を参照
  has_many :followers, through: :followeds, source: :follower  # ユーザのフォロワーリストで表示 中間テーブル経由でcurrent_userをフォローしたユーザの情報を参照

end
