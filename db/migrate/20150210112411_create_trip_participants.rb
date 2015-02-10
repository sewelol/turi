class CreateTripParticipants < ActiveRecord::Migration
  def change
    create_table :trip_participants do |t|
      t.references :account, index: true
      t.string :flag

      t.timestamps null: false
    end
    add_foreign_key :trip_participants, :accounts
  end
end
