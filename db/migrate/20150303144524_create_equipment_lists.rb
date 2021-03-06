class CreateEquipmentLists < ActiveRecord::Migration
  def change
    create_table :equipment_lists do |t|
      t.string :name
      t.string :description
      t.string :icon

      t.timestamps null: false
    end
      add_reference :equipment_lists, :trip, index: true
      add_foreign_key :equipment_lists, :trips
  end
end
