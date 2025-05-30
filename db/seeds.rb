require 'open-uri'
require 'faker'

Faker::Config.locale = 'ja'

puts "Creating 20 users..."
users = []
20.times do |i|
  name = Faker::Name.name
  # ランダムなパスワードを生成（8〜12文字）
  random_password = Faker::Internet.password(min_length: 8, max_length: 12)
  users << User.create!(
    name: name,
    email: Faker::Internet.email(name: name),
    password: random_password
  )
  puts "  Created user #{i + 1}: #{name} (password: #{random_password})"
end

puts "Creating 100 posts with thumbnails..."
post_count = 0
users.each do |user|
  # ユーザーごとに投稿数をランダムに分配（合計100件になるよう調整）
  remaining_users = users.length - users.index(user)
  remaining_posts = 100 - post_count

  # 各ユーザーに少なくとも1つの投稿を割り当て、残りをランダムに分配
  min_posts = 1
  max_additional_posts = [(remaining_posts - remaining_users) / remaining_users, 0].max * 2

  # 最小値は1、最大値は計算された値と残りの投稿数の小さい方
  num_posts = min_posts + rand(0..max_additional_posts)
  # 残り投稿数を超えないよう調整
  num_posts = [num_posts, remaining_posts].min

  num_posts.times do |i|
    post_count += 1
    break if post_count > 100

    # Fakerを使ってよりリアルなコンテンツを生成
    title = Faker::Lorem.sentence(word_count: rand(3..8)).chop
    content = Faker::Lorem.paragraphs(number: rand(3..8)).join("\n\n")

    post = user.posts.create!(
      title: title,
      content: content,
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
