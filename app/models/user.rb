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

  # サムネイル
  has_one_attached :thumbnail

  def get_thumbnail(width, height)
    unless thumbnail.attached?
      file_path = Rails.root.join('app/assets/images/no_thumbnail.jpg') # サムネイル未登録時の画像
      thumbnail.attach(io: File.open(file_path), filename: 'no_thumbnail.jpg', content_type: 'image/jpeg') # jpegのみ許可
    end
    thumbnail.variant(resize_to_limit: [width, height]).processed
  end

  # Post アソシエーション
  has_many :arts, dependent: :destroy # ユーザが退会した時に関連する投稿を全て削除する

  # Comment アソシエーション
  has_many :comments

  # Like アソシエーション
  has_many :likes

#------------------------------

  # Follow アソシエーション
  has_many :followers, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy # current_userがフォローしているユーザ
  has_many :followeds, class_name: 'Follow', foreign_key: 'followed_id', dependent: :destroy # current_userをフォローしているユーザ
  has_many :my_followers, through: :followers, source: :followed  # ユーザのフォローリストで表示   current_userがフォローしているユーザの情報を参照
  has_many :my_followeds, through: :followeds, source: :follower  # ユーザのフォロワーリストで表示 current_userをフォローしているユーザの情報を参照

  # フォロー 追加処理
  def follow(user_id)
    followers.create(followed_id: user_id)
  end
  # フォロー 解除処理
  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end
  # フォロー 判定処理
  def following?(user)
    my_followers.include?(user)
  end

#------------------------------

  # Notice アソシエーション
  has_many :active_notices, class_name: 'Notice', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notices, class_name: 'Notice', foreign_key: 'visited_id', dependent: :destroy

  # フォローの通知機能
  def create_notice_follow(current_user)
    temp = Notice.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notice = current_user.active_notices.new(
        visited_id: id,
        action: 'follow'
      )
      notice.save if notice.valid?
    end
  end

end

# 退会後の処理
#--------------------------------------------------------------------------------------------------------------------------------------------

  # 削除
    # Art                    ユーザ作品保護の為
    # Artに関連するComment   Artを削除することで投稿コメントの閲覧ができなくなる為
    # Artに関連するLike      Artを削除することで投稿自体の閲覧ができなくなる為
    # ArtTag                 Artを削除することで投稿自体の閲覧ができなくなる為
    # Comment                親コメントはデフォルトで物理削除の為
    # Follow                 退会済みユーザのフォローが不要の為
    # Notice                 退会済みユーザだけのものである為

  # 論理削除
    # User     退会したユーザの情報        悪戯防止と以下の情報を残す為
    # replies  他者のコメントに対する返信  コメントの返信の文脈が合わなくなる為          内容を「コメントは削除されました」に変更
    # Like     他者の投稿にたいするいいね  退会する度に投稿のいいねが減少する事を防ぐ為  いいねしたユーザを「退会済みユーザ」に変更

#--------------------------------------------------------------------------------------------------------------------------------------------