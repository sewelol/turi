class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :discussion, index: true, required: true
      t.references :user, index: true, required: true

      t.timestamps null: false
    end
    add_foreign_key :comments, :discussions
    add_foreign_key :comments, :users
  end
end
