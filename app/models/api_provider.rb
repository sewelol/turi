class ApiProvider < ActiveRecord::Base

  scope :dropbox, -> { find_by(name: 'dropbox') }

  def dropbox?
    name == 'dropbox'
  end

end
