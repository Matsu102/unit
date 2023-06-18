class CreateNotices < ActiveRecord::Migration[6.1]
  def change
    create_table :notices do |t|

      # 追加カラム ここから

      t.integer :visitor_id, null: false # 通知したユーザ
      t.integer :visited_id, null: false # 通知されたユーザ
      t.integer :art_id
      t.integer :follow_id
      t.integer :like_id
      t.integer :comment_id
      t.string  :action,     null: false
      t.boolean :checked,    null: false, default: false # 確認ステータス false:未読 true:既読

      # 追加カラム ここまで

      t.timestamps
    end
  end
end
