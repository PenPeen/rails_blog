FactoryBot.define do
  factory :token do
    association :user, factory: :user
    uuid { SecureRandom.uuid }
    expired_at { 1.day.from_now }
  end
end
