class Route < ActiveRecord::Base


  belongs_to :trip
  has_many :waypoints, :dependent => :delete_all

  accepts_nested_attributes_for :waypoints

end
