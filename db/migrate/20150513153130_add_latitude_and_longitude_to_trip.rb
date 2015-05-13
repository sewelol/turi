class AddLatitudeAndLongitudeToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :start_loc_latitude, :float
    add_column :trips, :start_loc_longitude, :float
    add_column :trips, :end_loc_latitude, :float
    add_column :trips, :end_loc_longitude, :float
  end
end
