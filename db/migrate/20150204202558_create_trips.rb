class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.text :title
      t.text :description
      t.text :start_loc
      t.text :end_loc
      t.text :image

      t.timestamps null: false
    end
  end
end
