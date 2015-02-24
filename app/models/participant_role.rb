class ParticipantRole < ActiveRecord::Base

  scope :owner, -> { find_by(name: 'owner') }
  scope :editor, -> { find_by(name: 'editor') }
  scope :viewer, -> { find_by(name: 'viewer') }

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
