FactoryGirl.define do
  
    factory :trip do |t|
        t.sequence(:title) { |n| "MyTrip#{n}" }
        t.description 'MyDescription'
        t.start_loc 'Tromso'
        t.end_loc 'LA'
        t.image 'https://lh6.googleusercontent.com/-EP_HfNwId-o/AAAAAAAAAAI/AAAAAAAAABo/QrC2Q7388Ew/photo.jpg'
    end
  
end