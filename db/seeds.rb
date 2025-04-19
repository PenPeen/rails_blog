require 'open-uri'
require 'faker'

Faker::Config.locale = 'ja'

puts "Creating 20 users..."
users = []
20.times do |i|
  name = Faker::Name.name
  users << User.create!(
    name: name,
    email: Faker::Internet.email(name: name),
    password: "password"
  )
  puts "  Created user #{i + 1}: #{name}"
end

puts "Creating 100 posts with thumbnails..."
post_count = 0
users.each do |user|
  # ユーザーごとに投稿数をランダムに分配（合計100件になるよう調整）
  remaining_users = users.length - users.index(user)
  remaining_posts = 100 - post_count
  max_posts_per_user = [remaining_posts / remaining_users * 2, remaining_posts].min
  num_posts = rand(1..max_posts_per_user)

  num_posts.times do |i|
    post_count += 1
    break if post_count > 100

    # Fakerを使ってよりリアルなコンテンツを生成
    title = Faker::Lorem.sentence(word_count: rand(3..8)).chop
    content = Faker::Lorem.paragraphs(number: rand(3..8)).join("\n\n")

    post = user.posts.create!(
      title: title,
      content: content,
      top_image: "https://example.com/image#{rand(1..30)}.jpg",
      published: [true, true, true, false].sample # 75%の確率で公開
    )

    # ユニークな画像を取得するためにpost.idをseedとして使用
    thumbnail_url = "https://picsum.photos/seed/#{post.id}/200/300"
    thumbnail_file = URI.open(thumbnail_url)
    post.thumbnail.attach(
      io: thumbnail_file,
      filename: "thumbnail_#{post.id}.jpg",
      content_type: 'image/jpeg'
    )

    puts "  Created post #{post_count}/100: '#{title}' by #{user.name}"
  end
end

puts "Seed data creation completed!"
puts "Created data: #{User.count} users, #{Post.count} posts with unique thumbnails"
