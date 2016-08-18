FactoryGirl.define do
  factory :use_code do
    name do
      (
        10.times.to_a.map { Faker::Lorem.word } -
        UseCode.select(:name).map(&:name)
      ).sample
    end
  end

end
