FactoryGirl.define do
  factory :case_type do
    name do
      (
        10.times.to_a.map { Faker::Lorem.word } -
        CaseType.select(:name).map(&:name)
      ).sample
    end
  end

end
