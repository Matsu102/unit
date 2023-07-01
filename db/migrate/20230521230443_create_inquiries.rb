class CreateInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiries do |t|

      # 追加カラム ここから

      t.string  :last_name,      null: false
      t.string  :first_name,     null: false
      t.integer :user_id
      t.string  :email,          null: false
      t.text    :inquiry_name, null: false
      t.text    :inquiry_detail, null: false
      t.boolean :is_response, null: false, default: false # 対応ステータス false:未対応 true:対応済

      # 追加カラム ここまで

      t.timestamps
    end
  end
end
