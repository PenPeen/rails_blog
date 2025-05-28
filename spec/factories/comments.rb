FactoryBot.define do
  factory :comment do
    association :user
    association :post
    content { "This is a comment content" }
  end
end
