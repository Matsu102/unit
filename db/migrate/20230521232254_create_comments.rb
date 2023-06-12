class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|

      # 追加カラム ここから

      t.integer :art_id,     null: false
      t.integer :user_id,    null: false
      t.string  :body,       null: false
      t.integer :to_id
      t.boolean :is_deleted, null: false, default: false # 削除ステータス false:公開 true:削除

      # 追加カラム ここまで

      t.timestamps
    end
  end
end
