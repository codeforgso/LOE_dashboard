require File.expand_path(Rails.root)+'/lib/socrata'
FactoryGirl.define do
  factory :loe_case do
    ad_lot                    {Faker::Lorem.words.join(' ')}
    ad_sakey                  {Faker::Number.between(1, 10000)}
    ad_st_apt                 {Faker::Lorem.words.join(' ')}
    ad_st_name                {Faker::Lorem.words.join(' ')}
    ad_st_num                 {Faker::Lorem.words.join(' ')}
    ad_st_type                {Faker::Lorem.words.join(' ')}
    annex_date                {Time.now.advance(years: Faker::Number.between(1, 100)).to_date}
    assigned_inspector_code   {Faker::Lorem.words.join(' ')}
    assignment                {Faker::Lorem.words.join(' ')}
    case_notes                {Faker::Lorem.paragraphs.join("\n\n")}
    sequence(:case_number)    { |n| Time.parse("2011/01/01").advance(days: n).strftime("%Y%m%d") }
    case_status               {Faker::Lorem.words.join(' ')}
    case_type                 {Faker::Lorem.words.join(' ')}
    census_tract              {Faker::Lorem.words.join(' ')}
    close_date                {Time.now.advance(days: Faker::Number.between(1, 10000))}
    close_reason              {Faker::Lorem.words.join(' ')}
    due_date                  {Time.now.advance(days: Faker::Number.between(1, 10000))}
    entry_date                {Time.now.advance(days: Faker::Number.between(1, 10000))}
    last_update               {Time.now.advance(days: Faker::Number.between(1, 10000))}
    origin                    {Faker::Lorem.words.join(' ')}
    owner_mailaddr            {Faker::Address.street_address}
    owner_mailaddr2           {Faker::Address.secondary_address}
    owner_mailcity            {Faker::Address.city}
    owner_mailstate           {Faker::Address.state_abbr}
    owner_mailzip             {Faker::Address.zip}
    owner_name                {Faker::Name.name}
    owner_name2               {Faker::Name.name}
    rental_status             {Faker::Lorem.words.join(' ')}
    use_code                  {Faker::Lorem.words.join(' ')}
    zoning                    {Faker::Lorem.words.join(' ')}
    st_name                   {Faker::Address.street_name.upcase}
  end
end