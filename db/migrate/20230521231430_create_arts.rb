class CreateArts < ActiveRecord::Migration[6.1]
  def change
    create_table :arts do |t|

      # 追加カラム ここから

      t.integer :user_id, null: false
      t.string  :title,   null: false
      t.text    :detail,  null: false
      t.boolean :is_deleted, null: false, default: false # 削除ステータス false:公開 true:削除

      # 追加カラム ここまで

      t.timestamps
    end
  end
end
