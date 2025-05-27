# frozen_string_literal: true

class DeletePostService
  Result = Struct.new(:post, :success, :message, :errors, keyword_init: true)

  attr_reader :user, :post_id

  def initialize(user:, post_id:)
    @user = user
    @post_id = post_id
  end

  def call
    begin
      post = find_post
      post.destroy!

      Result.new(
        post: post,
        success: true,
        message: "投稿を削除しました。",
        errors: nil
      )
    rescue ActiveRecord::RecordNotFound
      Result.new(
        post: nil,
        success: false,
        message: "投稿が見つかりません。",
        errors: nil
      )
    rescue => e
      Result.new(
        post: nil,
        success: false,
        message: "削除に失敗しました。しばらく経ってから再度実行してください。",
        errors: [
          { message: "削除処理に失敗しました: #{e.message}" }
        ]
      )
    end
  end

  private
    def find_post
      @post ||= user.posts.find(post_id)
    end
end
