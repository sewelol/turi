class ApiAccessToken < ActiveRecord::Base

  belongs_to :api_provider
  belongs_to :trip
  belongs_to :user

  validates_presence_of :token

  def self.for_trip_user_provider(trip, user, api_provider)
    find_by(trip_id: trip.id, user_id: user.id, api_provider_id: api_provider.id)
  end

end
