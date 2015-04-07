class Article < ActiveRecord::Base
  belongs_to :trip
  validates :title, presence: true
  validates :content, presence: true

end
