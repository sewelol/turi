class Event < ActiveRecord::Base
  belongs_to :trip

  validates_presence_of :name
  validates_presence_of :color
  validates_presence_of :start_date
  validates_presence_of :end_date

  validate :start_date_before_end_date

  def start_date_before_end_date
    if start_date.nil? || end_date.nil? || start_date >= end_date
      errors.add(:start_date, 'has to be before the end date')
    end
  end

end
