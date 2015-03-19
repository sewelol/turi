FactoryGirl.define do
  factory :friendship do |f|
    f.sequence(:user_id) { |n| "user#{n}" }
    f.sequence(:friend_id) { |n| "friend#{n}" }
  end

end
