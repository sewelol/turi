class AddPublicSettingToTrips < ActiveRecord::Migration
  def change
      # lets be nice, and set everything to false. Let the user get some privacy dammit! 
      add_column :trips, :public, :boolean, :default => false
      add_column :trips, :share_gallery, :boolean, :default => false
      add_column :trips, :share_equipment_price, :number, :default => 0
  end
end
