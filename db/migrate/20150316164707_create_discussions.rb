class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.references :trip, index: true, required: true
      t.references :user, index: true, required: true
      t.text :title, null: false
      t.text :body

      t.timestamps null: false
    end
    add_foreign_key :discussions, :trips
    add_foreign_key :discussions, :users
  end
end
