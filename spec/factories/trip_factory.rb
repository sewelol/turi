FactoryGirl.define do
  
    factory :trip do |t|
        t.sequence(:title) { |n| "My trip to Oslo Number #{n}" }
        t.description 'A beautiful trip to Oslo with my friends.'
        t.start_loc 'Tromsø'
        t.end_loc 'Oslo'
        t.image 'https://unsplash.it/1060/260?random'
    end
  
end
