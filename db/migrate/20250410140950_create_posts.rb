class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.string :top_image
      t.boolean :published

      t.timestamps
    end
  end
end
