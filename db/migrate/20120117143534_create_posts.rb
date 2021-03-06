class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :idx
      t.integer :notification
      t.text :subject
      t.text :text

      t.timestamps
    end
  end
end
