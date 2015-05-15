FactoryGirl.define do

  factory :request do |u|
    u.sequence(:user_id) { |n| "#{n}"}
    u.sequence(:receiver_id) { |n| "#{n+1}"}
  end

end
