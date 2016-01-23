FactoryGirl.define do
  factory :violation do
    loe_case
    ad_st_apt               {Faker::Lorem.words.join(' ')}
    ad_st_name              {Faker::Lorem.words.join(' ')}
    ad_st_num               {Faker::Lorem.words.join(' ')}
    ad_st_type              {Faker::Lorem.words.join(' ')}
    case_number             {Faker::Number.between(1, 10000)}
    case_sakey              {Faker::Number.between(1, 10000)}
    clear_date              {Time.now.advance(days: Faker::Number.between(1, 10000))}
    cleared_by              {Faker::Lorem.words.join(' ')}
    comments                {Faker::Lorem.paragraphs.join("\n\n")}
    entry_date              {Time.now.advance(days: Faker::Number.between(1, 10000))}
    issued_by               {Faker::Lorem.words.join(' ')}
    issued_date             {Time.now.advance(days: Faker::Number.between(1, 10000))}
    last_update             {Time.now.advance(days: Faker::Number.between(1, 10000))}
    major_violation         {Faker::Lorem.words.join(' ')}
    number_of_items         {Faker::Number.between(1, 10000)}
    reissue_date            {Time.now.advance(days: Faker::Number.between(1, 10000))}
    reissued_by             {Faker::Lorem.words.join(' ')}
    responsible_party       {Faker::Lorem.words.join(' ')}
    violation_cleared       {Faker::Lorem.words.join(' ')}
    violation_code          {Faker::Lorem.words.join(' ')}
    violation_description   {Faker::Lorem.words.join(' ')}
    violation_issued        {Faker::Lorem.words.join(' ')}
    violation_reissued      {Faker::Lorem.words.join(' ')}
    violation_sakey         {Faker::Number.between(1, 10000)}

    after(:build) do |violation|
      violation.case_number = violation.loe_case.case_number
    end
  end

end
