FactoryGirl.define do
  factory :inspection do
    loe_case
    ad_st_apt                 {Faker::Lorem.words.join(' ')}
    ad_st_name                {Faker::Lorem.words.join(' ')}
    ad_st_num                 {Faker::Lorem.words.join(' ')}
    ad_st_type                {Faker::Lorem.words.join(' ')}
    case_sakey                {Faker::Number.between(1, 10000)}
    compliant                 {Faker::Lorem.words.join(' ')}
    entry_date                {Time.now.advance(days: Faker::Number.between(1, 10000))}
    inspection_date           {Time.now.advance(days: Faker::Number.between(1, 10000))}
    inspection_notes          {Faker::Lorem.paragraphs.join("\n\n")}
    inspection_sakey          {Faker::Number.between(1, 10000)}
    inspection_type           {Faker::Lorem.words.join(' ')}
    inspection_type_desc      {Faker::Lorem.words.join(' ')}
    inspector                 {Faker::Lorem.words.join(' ')}
    last_update               {Time.now.advance(days: Faker::Number.between(1, 10000))}
    open_and_vacant           {Faker::Lorem.words.join(' ')}
    unfounded                 {Faker::Lorem.words.join(' ')}
    after(:build) do |inspection|
      inspection.case_number = inspection.loe_case.case_number
    end
  end

end
