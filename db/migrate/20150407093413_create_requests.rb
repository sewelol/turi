class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.integer :receiver_id

      t.timestamps null: false
    end

    add_index :requests, [:user_id, :receiver_id], unique: true
  end
end
