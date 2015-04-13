class Discussion < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :trip
  belongs_to :user
  has_many :comments
end
