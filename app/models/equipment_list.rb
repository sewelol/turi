class EquipmentList < ActiveRecord::Base
    belongs_to :trip
    validates_presence_of :name
    validates_presence_of :description
end
