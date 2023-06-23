class Inquiry < ApplicationRecord

  # admin
  validates :is_response,    inclusion: {in: [true, false]}, on: :update # update時のみバリデーション

  #user
  validates :last_name,      presence: true
  validates :first_name,     presence: true
  #         :member_id       非会員からの問い合わせができなくなるためバリデーションなし
  validates :email,          presence: true
  validates :inquiry_name,   presence: true, length: { in: 1..30 }
  validates :inquiry_detail, presence: true, length: { in: 1..500 }

end
