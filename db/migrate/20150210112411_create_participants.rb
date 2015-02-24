class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.references :user, index: true
      t.references :trip, index: true
      t.string :flag

      t.timestamps null: false
    end
    add_foreign_key :participants, :trips
    add_foreign_key :participants, :users
  end
end
