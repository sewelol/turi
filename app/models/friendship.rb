class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => User

  has_many :friendships

  def self.request_exists(user_id, receiver_id)
    a = Request.exists?(user_id: receiver_id, receiver_id: user_id)
    b = Request.exists?(user_id: user_id, receiver_id: receiver_id)
    a || b
  end

  def self.friendship_exists(user_id, friend_id)
    a = Friendship.exists?(user_id: friend_id, friend_id: user_id)
    b = Friendship.exists?(user_id: user_id, friend_id: friend_id)
    a || b
  end

  def self.find_friendship(user_id, friend_id)
    Friendship.where("user_id = ? and friend_id = ? OR")
  end
end
