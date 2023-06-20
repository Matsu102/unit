class Art < ApplicationRecord

  validates :image,  presence: true
  validates :title,  presence: true
  validates :detail, presence: true

  # 作品
  has_one_attached :image

  # artのnewページとeditページの:tagsbodyに仮想カラム
  attr_accessor :tagsbody

  # User アソシエーション
  belongs_to :user

  # ArtTag アソシエーション
  has_many :art_tags, dependent: :destroy # 投稿が削除された時に関連するタグを全て削除する
  has_many :tags,     through:   :art_tags

  # Comment アソシエーション
  has_many :comments, dependent: :destroy # 投稿が削除された時に関連するコメントを全て削除する

  # Like アソシエーション
  has_many :likes, dependent: :destroy # 投稿が削除された時に関連するいいねを全て

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
  def create_notice_comment(current_user, comment_id)
    target_comment = Comment.find(comment_id)
    if target_comment.to_id == nil # コメントが親の場合
      temp_ids = []
    else
      temp_ids = Comment.select(:user_id).where(to_id: target_comment.to_id).where.not(user_id: current_user.id).or(Comment.where(id: target_comment.to_id)).distinct # 親コメントのidと一致するコメントを検索 & 自分のコメントは検索しない
    end
    temp_ids.each do |temp_id|
      save_notice_comment(current_user, comment_id, temp_id['user_id'])
    end
    save_notice_comment(current_user, comment_id, user_id) #if temp_ids.blank?
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