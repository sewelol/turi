class UserTrip < ActiveRecord::Base
  belongs_to :user

  # FIXME: Should be one to one?!
  has_many :trips
  
end
