class AddUniqueParticipantRole < ActiveRecord::Migration
  def change
    add_index :participant_roles, :name, :unique => true
  end
end
