class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.text :description, default: ''
      t.string :color, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.references :trip, index: true, required: true

      t.timestamps null: false
    end
    add_foreign_key :events, :trips
  end
end
