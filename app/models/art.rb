class Art < ApplicationRecord

  validates :image,  presence: true
  validates :title,  presence: true
  validates :detail, presence: true

  # 作品
  has_one_attached :image
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
  def _tags_save(tag_names)
    tag_names.each do |tag_name|
      # Todo: 既存のタグは保存しない
      # Todo: 更新時にart_tagsの紐付けを外す
      tag = Tag.new(tag: tag_name)
      tag.save
      art_tag = tag.art_tags.new(art_id: id)
      art_tag.save
    end
  end
  def tags_save(sent_tags)
  # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:tag) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags
    pp current_tags
    pp old_tags
    pp new_tags

    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag: old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(tag: new)
      self.tags << new_post_tag
   end
  end

end
