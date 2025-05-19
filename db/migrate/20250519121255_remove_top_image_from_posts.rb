class RemoveTopImageFromPosts < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :top_image, :string
  end
end
