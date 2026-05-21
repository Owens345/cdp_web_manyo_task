FactoryBot.define do
  factory :label do
    sequence(:name) { |n| "label_#{n}" }
    association :user
  end
end