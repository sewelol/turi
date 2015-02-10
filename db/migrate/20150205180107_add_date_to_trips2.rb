class AddDateToTrips2 < ActiveRecord::Migration
  def change
      remove_column :trips, :start_date, :date
      remove_column :trips, :end_date, :date
      add_column :trips, :start_date, :text
      add_column :trips, :end_date, :text
  end
end
