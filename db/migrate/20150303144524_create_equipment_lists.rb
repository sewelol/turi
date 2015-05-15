class CreateEquipmentLists < ActiveRecord::Migration

  def change
    create_table :equipment_lists do |t|
      t.string :name, null: false
      t.string :description

      t.timestamps null: false
    end

    add_reference :equipment_lists, :trip, index: true
    add_foreign_key :equipment_lists, :trips

    add_reference :equipment_lists, :user, index: true
    add_foreign_key :equipment_lists, :users

  end
end
