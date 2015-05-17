class AddImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :image, :text
    add_column :users, :cover_image, :text
  end
end
