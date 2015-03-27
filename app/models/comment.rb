class Comment < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :user

  validates_presence_of :body
end
