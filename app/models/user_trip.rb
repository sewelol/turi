class UserTrip < ActiveRecord::Base
  belongs_to :account
  has_many :trips
  
end
