FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'password' }
    admin { false }
  end

  factory :admin_user, class: User do
    sequence(:name) { |n| "admin_#{n}" }
    sequence(:email) { |n| "admin_#{n}@example.com" }
    password { 'password' }
    admin { true }
  end
end
