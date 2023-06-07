class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :last_name,        presence: true
  validates :first_name,       presence: true
  validates :handle_name,      presence: true
  validates :telephone_number, presence: true, uniqueness: true
  validates :url,              format: /\A#{URI::regexp(%w(http https))}\z/, allow_blank: true, on: :update # 入力制限 update時のみバリデーション
  validates :introduction,     length: { maximum: 200 },                     on: :update # update時のみバリデーション
  validates :user_type,        presence: true
  validates :is_locked,        inclusion: {in: [true, false]},               on: :update # update時のみバリデーション
  validates :thumbnail,        presence: true,                               on: :update # update時のみバリデーション

  # 管理者側 ユーザ検索機能

  # サムネイル
  has_one_attached :thumbnail

  def get_thumbnail(width, height)
    unless thumbnail.attached?
      file_path = Rails.root.join("app/assets/images/no_thumbnail.jpg") # サムネイル未登録時の画像
      thumbnail.attach(io: File.open(file_path), filename: "no_thumbnail.jpg", content_type: "image/jpeg") # jpegのみ許可
    end
    thumbnail.variant(resize_to_limit: [width, height]).processed
  end

  # Post アソシエーション
  has_many :arts, dependent: :destroy # ユーザが退会した時に関連する投稿を全て削除する

  # Comment アソシエーション
  has_many :comments

  # Like アソシエーション
  has_many :likes

  # Follow アソシエーション
  has_many :followers, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy # followers == Followモデルのfollower_id == フォローしたユーザのid == current_userがフォローしているユーザ
  has_many :followeds, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy # followeds == Followモデルのfollowed_id == フォローされたユーザのid == current_userをフォローしているユーザ
  has_many :followings, through: :followers, source: :followed # ユーザのフォローリストで表示   中間テーブル経由でcurrent_userがフォローしたユーザ情報を参照
  has_many :followers, through: :followeds, source: :follower  # ユーザのフォロワーリストで表示 中間テーブル経由でcurrent_userをフォローしたユーザの情報を参照

  # Notice アソシエーション
  has_many :notices, dependent: :destroy

end

# 退会後の処理
#--------------------------------------------------------------------------------------------------------------------------------------------

  # 削除
    # Art                   ユーザ作品保護の為
    # Artに関連するComment   Artを削除することで投稿コメントの閲覧ができなくなる為
    # Artに関連するLike      Artを削除することで投稿自体の閲覧ができなくなる為
    # ArtTagとTag            Artを削除することで投稿自体の閲覧ができなくなる為
    # Follow                 退会済みユーザのフォローが不要の為
    # Notice                 退会済みユーザだけのものである為

  # 論理削除
    # User     退会したユーザの情報        悪戯防止と以下の情報を残す為
    # Comment  他者の投稿に対するコメント  コメントの返信の文脈が合わなくなる為          内容を「コメントは削除されました」に変更
    # Like     他者の投稿にたいするいいね  退会する度に投稿のいいねが減少する事を防ぐ為  いいねしたユーザを「退会済みユーザ」に変更

#--------------------------------------------------------------------------------------------------------------------------------------------