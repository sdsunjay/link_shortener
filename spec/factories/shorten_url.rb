# spec/factories/shorten_url.rb
factory :shorten_url do |f|
  f.original_url { Faker::Name.first_name }
  f.lastname { Faker::Name.last_name }
end
