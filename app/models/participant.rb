class Participant < ActiveRecord::Base

  belongs_to :trip
  belongs_to :user
  belongs_to :participant_role

end
