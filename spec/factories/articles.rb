FactoryGirl.define do

  factory :article do
    sequence(:title) { |n| "Update #{n} from the trip"}
    content 'Some content'
  end

end
