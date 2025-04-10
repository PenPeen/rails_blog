FactoryBot.define do
  factory :post do
    association :user
    sequence(:title) { |n| "投稿タイトル#{n}" }
    content { "これはテスト投稿の内容です。" }
    top_image { "https://example.com/image.jpg" }
    published { true }
  end
end
