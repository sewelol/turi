class ParticipantRole < ActiveRecord::Base

  scope :editor, -> { find_by(name: 'editor') }
  scope :viewer, -> { find_by(name: 'viewer') }

end
