# frozen_string_literal: true

class CreateCommentService
  Result = Struct.new(:comment, :errors, keyword_init: true)

  attr_reader :user, :post_id, :content

  def initialize(user:, post_id:, content:)
    @user = user
    @post_id = post_id
    @content = content
  end

  def call
    post = ::Post.find_by(id: post_id)

    unless post
      return Result.new(
        comment: nil,
        errors: [{ message: '投稿が見つかりません', path: ['createComment', 'post_id'] }]
      )
    end

    comment = user.comments.new(post:, content:)

    if comment.save
      Result.new(
        comment: comment,
        errors: nil
      )
    else
      Result.new(
        comment: nil,
        errors: comment.errors.map { |error| { message: error.full_message, path: ['createComment', error.attribute.to_s.camelize(:lower)] } }
      )
    end
  end
end
