class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|

      # 追加カラム ここから

      t.string :name, null: false

      # 追加カラム ここまで

      t.timestamps
    end
  end
end
