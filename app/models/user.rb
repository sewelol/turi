include Gravtastic

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of   :name
  validates_uniqueness_of :name

  # FRIENDSHIPS BEGIN
  has_many :friendships
  has_many :friends, :through => :friendships

  has_many :inverse_friendships, :class_name => Friendship, :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  has_many :requests
  has_many :requesters, :through => :requests
  # FRIENDSHIPS END

  gravtastic
  has_many :trips # Do not make this dependent! This var has to be removed (replaced by participant owner).
  has_many :participants, :dependent => :delete_all
  has_many :api_access_tokens, :dependent => :delete_all

  def self.search(name_search)
    users = []

    if name_search.present?
      users = User.where('name LIKE ?', "%#{name_search}%")
    end

    return users
  end
  
end
