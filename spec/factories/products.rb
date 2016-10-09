FactoryGirl.define do
  factory :product do
    name Faker::Name.name
    price 1
    stock_quantity 1
    category
  end
end