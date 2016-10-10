FactoryGirl.define do
  factory :user do
    name  Faker::Name.name
    email Faker::Internet.email
    user_type  "type"
  end
end