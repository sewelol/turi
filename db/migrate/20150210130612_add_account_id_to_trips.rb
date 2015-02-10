class AddAccountIdToTrips < ActiveRecord::Migration
  def change
    add_reference :trips, :account, index: true
    add_foreign_key :trips, :accounts
  end
end
