FactoryGirl.define do

  factory :api_provider do |t|
    t.sequence(:name) { |n| "my-api-provider-#{n}" }
  end

end
