FactoryBot.define do
  factory :session do
    association :user
    key { Session.generate_key }
  end
end
