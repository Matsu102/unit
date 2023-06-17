class Comment < ApplicationRecord

  validates :body, presence: true, length: { in: 1..150 }

  # User アソシエーション
  belongs_to :user

  # Post アソシエーション
  belongs_to :art

  # Notice アソシエーション
  has_many :notices, dependent: :destroy

  # Comment アソシエーション
  has_many :replies, class_name: "Comment", foreign_key: "to_id", dependent: :destroy # has_many > Commentは複数の返信を持っている  class_name > モデル名

  # Commentの通知機能
  def create_notice_comment(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notice_comment(current_user, comment_id, temp_id['user_id'])
    end
    save_notice_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notice_comment(current_user, comment_id, visited_id)
    notice = current_user.active_notifications.new(
      id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notice.visitor_id == notice.visited_id
      notice.checked = true
    end
    notice.save if notice.valid?
  end

end