class EquipmentList < ActiveRecord::Base
    belongs_to :trip
    belongs_to :user
    has_many :equipment_items, :dependent => :delete_all


    validates_presence_of :name
    validates_presence_of :description
    validates_presence_of :user
    validates_presence_of :trip
end
