class ParticipantRole < ActiveRecord::Base

  # Using scope is another way of writing a class method.
  # The first scope below is the same as writing this:
  # def self.owner
  #   find_by(name: 'owner')
  # end

  scope :owner, -> { find_by(name: 'owner') }
  scope :editor, -> { find_by(name: 'editor') }
  scope :viewer, -> { find_by(name: 'viewer') }

  # name is taken from the participant_role model.
  def owner?
    name == 'owner'
  end

  def editor?
    name == 'editor'
  end

  def viewer?
    name == 'viewer'
  end

end
