class Request < ActiveRecord::Base
  validate :cannot_add_self
  validate :cannot_add_when_already_added

  validates :user_id, :receiver_id, presence: true
  belongs_to :user
  belongs_to :receiver, :class_name => User

  private

  def cannot_add_self
    errors.add(:user_id, 'You cannot request yourself as a friend.') if user_id == receiver_id
  end

  def cannot_add_when_already_added
    requestExists = Request.exists?(user_id: receiver_id, receiver_id: user_id)
    #puts "Request does already exist? #{requestExists}"
    errors.add(:user_id,
              'You cannot add a request to someone who already requested to be your friend') if requestExists

  end
end
