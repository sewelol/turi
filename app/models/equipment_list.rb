class EquipmentList < ActiveRecord::Base

    belongs_to :trip
    belongs_to :user
    has_many :equipment_items, dependent: :delete_all

    validates_presence_of :name
    validates_presence_of :user
    validates_presence_of :trip

    def assigned_items_sum
      assigned_items_sum = 0
      self.equipment_items.each do |item|
        assigned_items_sum += item.assignments_sum
      end
      assigned_items_sum
    end

end
