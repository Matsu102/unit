class Inquiry < ApplicationRecord

  # admin
  validates :is_response,    inclusion: {in: [true, false]}, on: :update # update時のみバリデーション

  #user
  validates :last_name,      presence: { message: 'を入力してください。' }
  validates :first_name,     presence: { message: 'を入力してください。' }
  validates :member_id,      numericality: { message: 'は数字で入力してください。' }
  validates :email,          presence: true
  validates :inquiry_name,   presence: { message: 'を1～30文字入力してください。' }
  validates :inquiry_name,   length: { in: 1..30, message: 'は30文字以内で入力してください。' }, if: -> { inquiry_name.present? }
  validates :inquiry_detail, length: { in: 1..500 }
end