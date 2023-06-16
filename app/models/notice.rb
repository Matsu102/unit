class Notice < ApplicationRecord

  default_scope -> { order(created_at: :desc) }

  # Comment アソシエーション
  belongs_to :comment

  # Like アソシエーション
  belongs_to :like

  # Follow アソシエーション
  belongs_to :follow

  # User アソシエーション
  belongs_to :visitor, class_name: "User", foreign_key: "visitor_id", dependent: :destroy # 通知したユーザ
  belongs_to :visited, class_name: "User", foreign_key: "visited_id", dependent: :destroy # 通知されたユーザ
end
