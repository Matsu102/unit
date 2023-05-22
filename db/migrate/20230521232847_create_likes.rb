class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|

      # 追加カラム ここから

      t.integer :post_id, null: false
      t.integer :user_id, null: false

      # 追加カラム ここまで

      t.timestamps
    end
  end
end
