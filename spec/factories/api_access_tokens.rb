FactoryGirl.define do

  factory :api_access_token do |t|
    t.sequence(:token) { |n| "token-value-#{n}" }
  end

end
