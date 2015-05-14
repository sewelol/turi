class AddLatitudeAndLongitudeToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :start_loc_latitude, :float, null: true
    add_column :trips, :start_loc_longitude, :float, null: true
    add_column :trips, :end_loc_latitude, :float, null: true
    add_column :trips, :end_loc_longitude, :float, null: true
  end
end
