class CreateFollows < ActiveRecord::Migration[6.1]
  def change
    create_table :follows do |t|

      # 追加カラム ここから

      t.integer :follower_id, null: false # フォローしたユーザ
      t.integer :followed_id, null: false # フォローされたユーザ

      # 追加カラム ここまで

      t.timestamps
    end
  end
end
