FactoryBot.define do
  factory :post do
    association :user
    sequence(:title) { |n| "投稿タイトル#{n}" }
    content { "これはテスト投稿の内容です。" }
    published { true }
  end
end
