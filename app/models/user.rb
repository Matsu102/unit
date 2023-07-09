class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

#--------------------------------------------------

  validates :last_name,        presence: { message: 'を入力してください。' }
  validates :first_name,       presence: { message: 'を入力してください。' }
  validates :handle_name,      presence: { message: 'を入力してください。' }
  VALID_email = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,            format: { with: VALID_email, message: 'が不正です。'}, if: -> { email.present? }
  validates :email,            uniqueness: { message: 'は既に使用されています。' }, if: -> { email.present? }
  validates :telephone_number, presence: { message: 'を入力してください。' }
  VALID_telephone_number = /\A0[-\d]{11,12}\z/
  validates :telephone_number, format: { with: VALID_telephone_number, message: 'は半角数字とハイフンで入力してください。'}, if: -> { telephone_number.present? }
  validates :telephone_number, uniqueness: { message: 'は既に使用されています。' }, if: -> { telephone_number.present? }
  VALID_url = /\A#{URI::regexp(%w(http https))}\z/
  validates :url,              format: { with: VALID_url, message: 'は「http://」もしくは「https://」で始まる半角英数記号で入力してください。'}, allow_blank: true, on: :update # 入力制限 update時のみバリデーション
  validates :introduction,     length: { maximum: 200, message: 'は200文字以内で入力してください。' }, on: :update # update時のみバリデーション
  validates :user_type,        presence: true, inclusion: {in: ['artist', 'fan'], message: '会員種別が不正です。'}
  validates :is_locked,        inclusion: { in: [true, false], message: '公開ステータスが不正です。'}, on: :update # update時のみバリデーション
  validates :is_deleted,       inclusion: { in: [true, false], message: '退会ステータスが不正です。'}, on: :update # update時のみバリデーション
  validates :thumbnail,        presence: true, on: :update # update時のみバリデーション
  VALID_password = /(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!?-_.]){6,15}/
  validates :password,         presence: { message: 'を入力してください。' }, on: :create # create時のみバリデーション
  validates :password,         format: { with: VALID_password, message: 'は6～15文字の半角英数字と記号(!?-_.)を組み合わせて入力してください。'}, if: -> { password.present? }, on: :create
  validates :password,         confirmation: true, on: :create
  validate  :thumbnail_type, if: :was_attached?

#--------------------------------------------------

  # サムネイルのバリデーション
  has_one_attached :thumbnail
  def thumbnail_type
    extension = ['image/jpeg', 'image/png', 'image/gif']
    errors.add(:thumbnail, 'に使用できる拡張子は「JPEG」「PNG」「GIF」のみです。') unless thumbnail.content_type.in?(extension)
  end

  def was_attached?
    self.thumbnail.attached?
  end

#--------------------------------------------------

  # Post アソシエーション
  has_many :arts

  # Comment アソシエーション
  has_many :comments

  # Like アソシエーション
  has_many :likes

  # Follow アソシエーション
  has_many :followers, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy # current_userがフォローしているユーザ
  has_many :followeds, class_name: 'Follow', foreign_key: 'followed_id', dependent: :destroy # current_userをフォローしているユーザ
  has_many :my_followers, through: :followers, source: :followed  # ユーザのフォローリストで表示   current_userがフォローしているユーザの情報を参照
  has_many :my_followeds, through: :followeds, source: :follower  # ユーザのフォロワーリストで表示 current_userをフォローしているユーザの情報を参照

  # Notice アソシエーション
  has_many :active_notices, class_name: 'Notice', foreign_key: 'visitor_id'
  has_many :passive_notices, class_name: 'Notice', foreign_key: 'visited_id'

#--------------------------------------------------

  #サムネイル
  def get_thumbnail
    unless thumbnail.attached?
      file_path = Rails.root.join('app/assets/images/no_thumbnail.jpg') # サムネイル未登録時の画像
      thumbnail.attach(io: File.open(file_path), filename: 'no_thumbnail.jpg', content_type: 'image/jpeg') # jpegのみ許可
    end
    thumbnail
  end

#------------------------------

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

    # User                   論理削除       退会済みユーザー       関連ページアクセス不可
    # Art                    論理削除
    # Like                   データ据え置き 退会済みユーザー
    # ArtTag                 データ据え置き
    # Comment                論理削除
    # replies                論理削除       退会済みユーザー
    # Follow                 物理削除
    # Notice                 データ据え置き 退会済みユーザー

#--------------------------------------------------------------------------------------------------------------------------------------------

# 凍結後の処理
#--------------------------------------------------------------------------------------------------------------------------------------------

    # User                   非公開         アカウントは凍結されています  currentユーザのみアクセス可能  心当たりが無い場合はお問い合わせフォームよりご連絡ください
    # Art                    非公開         アクセス不可
    # Like                   データ据え置き アカウント凍結中
    # ArtTag                 データ据え置き アクセス不可
    # Comment                非公開         アカウント凍結中
    # replies                非公開         アカウント凍結中
    # Follow                 データ据え置き アカウント凍結中
    # Notice                 データ据え置き アカウント凍結中

#--------------------------------------------------------------------------------------------------------------------------------------------