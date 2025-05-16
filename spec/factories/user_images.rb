FactoryBot.define do
  factory :user_image do
    association :user, factory: :user
  end
end
