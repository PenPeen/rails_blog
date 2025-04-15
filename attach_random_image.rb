#!/usr/bin/env ruby
# 全てのPostにランダムな画像をアタッチするスクリプト

# 画像ファイルのパス（これを実際のパスに変更）
IMAGE_FILES = [
]

begin
  # すべてのポストを取得
  posts = Post.all
  puts "#{posts.count}件のポストが見つかりました。"

  # 各ポストにランダムな画像を添付
  posts.each do |post|
    # ランダムに画像パスを選択
    random_image_path = IMAGE_FILES.sample
    filename = File.basename(random_image_path)

    puts "ポスト ##{post.id} に #{filename} を添付中..."

    # 現在のサムネイルを削除（もし存在すれば）
    post.thumbnail.purge if post.thumbnail.attached?

    # 指定したパスから画像を添付
    # この例では実際のファイルパスが存在する必要があります
    begin
      post.thumbnail.attach(
        io: File.open(random_image_path),
        filename: filename,
        content_type: "image/jpeg"
      )
      puts "成功: ポスト ##{post.id} に #{filename} をアタッチしました"
    rescue Errno::ENOENT => e
      puts "エラー: ファイル #{random_image_path} が見つかりません"
    rescue => e
      puts "エラー (ポスト ##{post.id}): #{e.message}"
    end
  end

  puts "すべてのポストへの画像添付が完了しました"

rescue => e
  puts "エラー: #{e.message}"
  puts e.backtrace.join("\n")
  exit 1
end
