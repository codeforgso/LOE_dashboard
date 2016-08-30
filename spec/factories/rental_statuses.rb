FactoryGirl.define do
  factory :rental_status do
    name do
      (
        10.times.to_a.map { Faker::Lorem.word } -
        RentalStatus.select(:name).map(&:name)
      ).sample
    end
  end

end
