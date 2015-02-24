class TripParticipant < ActiveRecord::Base
  belongs_to :trip
  has_many :user
  
end
