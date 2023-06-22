class CreateMentions < ActiveRecord::Migration[6.1]
  def change
    create_table :mentions do |t|
      t.integer :user_id, null: false
      t.integer :comment_id, null: false

      t.timestamps
    end
  end
end
