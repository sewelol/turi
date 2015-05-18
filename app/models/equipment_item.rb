class EquipmentItem < ActiveRecord::Base

  belongs_to :equipment_list
  has_many :equipment_assignments, :dependent => :delete_all

  validates_presence_of :name
  validates_presence_of :price
  validates_presence_of :number
  validates_presence_of :user_id, allow_nil: false
  validates_presence_of :equipment_list_id, allow_nil: false

  def possible_assignments(assigned)
    self.number - self.assignments_sum + assigned
  end

  def assignments_sum
    self.equipment_assignments.sum(:number)
  end

end
