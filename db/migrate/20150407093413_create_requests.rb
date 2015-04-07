class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :requester_id
      t.integer :reciever_id

      t.timestamps null: false
    end
  end
end
