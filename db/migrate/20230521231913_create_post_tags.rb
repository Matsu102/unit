class CreatePostTags < ActiveRecord::Migration[6.1]
  def change
    create_table :post_tags do |t|

      # 追加カラム ここから

      t.integer :post_id, null: false
      t.integer :tag_id,  null: false

      # 追加カラム ここまで

      t.timestamps
    end
  end
end
