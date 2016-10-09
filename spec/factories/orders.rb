FactoryGirl.define do
  factory :order do
    user
    total 1
  end
end

FactoryGirl.define do
  factory :order_with_items, :parent => :order do |order|
    order_items { build_list :order_item, 3 }
  end
end
