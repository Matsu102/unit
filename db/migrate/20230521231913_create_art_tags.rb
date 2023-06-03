class CreateArtTags < ActiveRecord::Migration[6.1]
  def change
    create_table :art_tags do |t|

      # 追加カラム ここから

      t.integer :art_id,  null: false
      t.integer :tag_id,  null: false

      # 追加カラム ここまで

      t.timestamps
    end
  end
end
