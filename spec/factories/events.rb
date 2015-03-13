FactoryGirl.define do

  factory :event do |t|
    t.sequence(:name) { |n| "my-event-#{n}" }
    t.description "MyText"
    t.color "#FFFFFF"
    t.location "New York"
    t.start_date "2015-03-08 13:04:24"
    t.end_date "2015-03-12 14:04:24"
  end

end
