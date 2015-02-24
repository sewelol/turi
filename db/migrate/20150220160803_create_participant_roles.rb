class CreateParticipantRoles < ActiveRecord::Migration
  def change
    create_table :participant_roles do |t|

      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
