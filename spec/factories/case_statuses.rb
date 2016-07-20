FactoryGirl.define do
  factory :case_status do
    name { Faker::Lorem.word }
  end
  factory :case_status_open, parent: :case_status do
    name 'Open'
  end
  factory :case_status_closed, parent: :case_status do
    name 'Closed'
  end

end
