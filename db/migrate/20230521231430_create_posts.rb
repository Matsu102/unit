class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|

      # 追加カラム ここから

      t.integer :user_id, null: false
      t.string  :title,   null: false
      t.text    :detail,  null: false

      # 追加カラム ここまで

      t.timestamps
    end
  end
end
