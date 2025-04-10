puts "Creating users..."
users = []
3.times do |i|
  users << User.create!(
    name: "ユーザー#{i + 1}",
    email: "user#{i + 1}@example.com",
    password: "password"
  )
  puts "  Created user #{i + 1}"
end

puts "Creating posts..."
users.each do |user|
  5.times do |i|
    post = user.posts.create!(
      title: "#{user.name}の投稿 #{i + 1}",
      content: "これは#{user.name}の#{i + 1}番目の投稿です。サンプルコンテンツが入ります。",
      top_image: "https://example.com/image#{rand(1..10)}.jpg",
      published: [true, false].sample
    )
    puts "  Created post #{i + 1} for #{user.name}"
  end
end

puts "Seed data creation completed!"
puts "Created data: #{User.count} users, #{Post.count} posts"
