require 'securerandom'

FactoryGirl.define do
  factory :user do
    name SecureRandom.hex
    email SecureRandom.hex << '@turi.no'
    password '12345678'
  end

end