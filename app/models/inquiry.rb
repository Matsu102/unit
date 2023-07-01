class Inquiry < ApplicationRecord

  # admin
  validates :is_response,    inclusion: {in: [true, false]}, on: :update # update時のみバリデーション

  #user
  validates :last_name,      presence: { message: 'を入力してください。' }
  validates :first_name,     presence: { message: 'を入力してください。' }
  validates :user_id,      numericality: { message: 'は数字で入力してください。' }, if: -> { member_id.present? }
  validates :email,          presence: { message: 'を入力してください。' }
  validates :inquiry_name,   presence: { message: 'を30文字入力してください。' }
  validates :inquiry_name,   length: { in: 1..30, message: 'に入力できるのは30文字までです。' }, if: -> { inquiry_name.present? }
  validates :inquiry_detail, presence: { message: 'を500文字入力してください。' }
  validates :inquiry_detail, length: { in: 1..500, message: 'に入力できるのは500文字までです。' }, if: -> { inquiry_detail.present? }

end