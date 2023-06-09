class Notice < ApplicationRecord

#--------------------------------------------------

  # Comment アソシエーション
  belongs_to :comment, optional: true

  # Art アソシエーション
  belongs_to :art, optional: true

  # User アソシエーション
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true # 通知したユーザ
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id',  optional: true # 通知されたユーザ

#--------------------------------------------------

  default_scope -> { order(created_at: :desc) } # 新しい通知から取得

end
