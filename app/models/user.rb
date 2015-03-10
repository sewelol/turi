include Gravtastic

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of   :name
  validates_uniqueness_of :name

  has_many :friendships
  has_many :friends, :through => :friendships

  def self.search(name_search, email_search)
    @user = nil
    if name_search.present? || email_search.present?
      @user = User.where('name LIKE ? AND email LIKE ?', "%#{name_search}%", "%#{email_search}%")
    end
    return @user
  end

  gravtastic
  has_many :trips
  has_many :participants
  
end
