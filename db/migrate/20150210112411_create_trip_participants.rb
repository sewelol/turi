class CreateTripParticipants < ActiveRecord::Migration
  def change
    create_table :trip_participants do |t|
      t.references :user, index: true
      t.references :trip, index: true
      t.string :flag

      t.timestamps null: false
    end
    add_foreign_key :trip_participants, :trips
    add_foreign_key :trip_participants, :users
  end
end
