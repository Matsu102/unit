class Like < ApplicationRecord

  # User アソシエーション
  belongs_to :user

  # Post アソシエーション
  belongs_to :art

  # Notice アソシエーション
  has_many :notices
  
  # Like通知機能
  def create_notice_like(current_user)
    temp = Notice.where(["visitor_id = ? and visited_id = ? and id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    if temp.blank?
      notice = current_user.active_notice.new(
        id: id,
        visited_id: user_id,
        action: 'like'
      )
      if notice.visitor_id == nnotice.visited_id
        notice.checked = true
      end
      notice.save if notice.valid?
    end
  end

end
