class Notice < ApplicationRecord

  default_scope -> { order(created_at: :desc) } # 新しい通知から取得

  # Comment アソシエーション
  belongs_to :comment, optional: true

  belongs_to :art, optional: true

  # User アソシエーション
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', dependent: :destroy, optional: true # 通知したユーザ
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', dependent: :destroy, optional: true # 通知されたユーザ
end
