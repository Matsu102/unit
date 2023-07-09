class Art < ApplicationRecord

#--------------------------------------------------

  validates :image,  presence: { message: 'をアップロードしてください。' }, on: :create
  validate  :image_type, if: :was_attached?
  validates :title,  presence: { message: 'を30文字以内で入力してください。' }
  validates :title,  length: { in: 1..30, message: 'に入力できるのは30文字までです。' }, if: -> { title.present? }
  validates :detail, presence: { message: 'を200文字以内で入力してください。' }
  validates :detail, length: { in: 1..200, message: 'に入力できるのは200文字までです。' }, if: -> { detail.present? }

#--------------------------------------------------

  # 作品のバリデーション
  has_one_attached :image
  def image_type
    extension = ['image/jpeg']
    errors.add(:image, "に使用できる拡張子は「JPEG」のみです。") unless image.content_type.in?(extension)
  end

  def was_attached?
    self.image.attached?
  end

#--------------------------------------------------

  # artのnewページとeditページの:tagsbodyに仮想カラム
  attr_accessor :tagsbody

  # User アソシエーション
  belongs_to :user

  # ArtTag アソシエーション
  has_many :art_tags
  has_many :tags,     through:   :art_tags

  # Comment アソシエーション
  has_many :comments

  # Like アソシエーション
  has_many :likes

#--------------------------------------------------

  # Likesテーブルにuser.idが存在するか調べる true => いいね中 false => いいねなし
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  # タグの保存と更新
  def tags_save(new_tags)
  old_tags = self.tags.pluck(:name) unless self.tags.nil? # @artに紐付けられたタグが存在する場合、タグの名前を配列として全て取得
    # 古いタグを全て削除 (タグを登録順にソートするため)
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old) # Tagテーブルのnameに一致するArtTagレコードを削除する
    end
    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new) # Tagテーブルに同一タグが存在する場合は何もしない 存在しない場合は新規登録する (Tagテーブルのデータ圧迫防止)
      self.tags << new_post_tag # @artとTagの紐付けを行う
    end
  end

  # コメントの通知機能
  def create_notice_comment(current_user, comment) # 第三引数 メンション
    save_notice_comment(current_user, comment, user_id) # メンション機能追加予定 (カラム1つ必要) ifで
  end

  def save_notice_comment(current_user, comment_id, visited_id)
    notice = current_user.active_notices.new(
      art_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notice.visitor_id == notice.visited_id
      notice.checked = true
    end
    notice.save! if notice.valid?
  end

  # いいねの通知機能
  def create_notice_like(current_user)
    temp = Notice.where(["visitor_id = ? and visited_id = ? and art_id = ? and action = ? ", current_user.id, user_id, id, "like"])
    if temp.blank?
      notice = current_user.active_notices.new(
        art_id: id,
        visited_id: user_id,
        action: 'like'
      )
      if notice.visitor_id == notice.visited_id
        notice.checked = true
      end
      notice.save if notice.valid?
    end
  end

end