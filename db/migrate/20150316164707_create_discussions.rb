class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.references :trip, index: true
      t.references :user, index: true
      t.text :title
      t.text :body

      t.timestamps null: false
    end
    add_foreign_key :discussions, :trips
    add_foreign_key :discussions, :users
  end
end
