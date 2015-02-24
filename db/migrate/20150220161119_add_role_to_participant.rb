class AddRoleToParticipant < ActiveRecord::Migration
  def change

    remove_column :participants, :flag

    add_reference :participants, :participant_role, index: true
    add_foreign_key :participants, :participant_roles

  end
end
