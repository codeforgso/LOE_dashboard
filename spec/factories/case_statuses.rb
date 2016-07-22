FactoryGirl.define do
  factory :case_status do
    name do
      (
        10.times.to_a.map { Faker::Lorem.word } -
        CaseStatus.select(:name).map(&:name)
      ).sample
    end
  end
  factory :case_status_open, parent: :case_status do
    name 'Open'
  end
  factory :case_status_closed, parent: :case_status do
    name 'Closed'
  end

end
