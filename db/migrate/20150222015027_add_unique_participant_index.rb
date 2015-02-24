class AddUniqueParticipantIndex < ActiveRecord::Migration
  def change

    add_index :participants, [:user_id, :trip_id], :unique => true

  end
end
