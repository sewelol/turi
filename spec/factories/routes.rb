FactoryGirl.define do
  factory :route do
    title "My Title"
    desc "My description"
  end
  trait :waypoint do
    desc "waypoint title"
    lat 20.00
    lng 30.30
    typ "pin"
  end

end
