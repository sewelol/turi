class Account < ActiveRecord::Base
  
  validates :username, presence: true , uniqueness: true
  validates :email, presence: true , uniqueness: true
  validates :password, presence: true, length: { minimum: 3 } # Minimum should be higher, but 3 is ok while testing
  has_secure_password # Compares password with password_confirmation, then digests the password and passes it to the database as password_digest

end
