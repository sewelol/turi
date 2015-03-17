FactoryGirl.define do

  factory :user do |u|
    u.sequence(:name) { |n| "user#{n}" }
    u.sequence(:email) { |n| "user#{n}@turi.no" }
    u.password '12345678'
  end

  factory :invalid_user, parent: :user do |u|
    u.name nil
  end

end