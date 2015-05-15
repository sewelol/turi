class AddPublicSettingToTrips < ActiveRecord::Migration
  def change
      # lets be nice, and set everything to false. Let the user get some privacy dammit! 
      add_column :trips, :public, :boolean, default: false
      add_column :trips, :public_gallery, :boolean, default: false
      add_column :trips, :price, :decimal, default: 0.0
  end
end
