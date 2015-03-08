include Gravtastic

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of   :name
  validates_uniqueness_of :name

  gravtastic
  has_many :trips # Do not make this dependent! This var has to be removed (replaced by participant owner).
  has_many :participants, :dependent => :delete_all
  has_many :api_access_tokens, :dependent => :delete_all
  
end
