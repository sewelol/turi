class CreateUserTrips < ActiveRecord::Migration
  def change
    create_table :user_trips do |t|
      t.references :trip, index: true
      t.string :flag

      t.timestamps null: false
    end
    add_foreign_key :user_trips, :trips
  end
end
