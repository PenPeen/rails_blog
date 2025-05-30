# frozen_string_literal: true

class UpdatePostService
  MAX_FILE_SIZE = 2.megabytes

  Result = Struct.new(:post, :message, :errors, keyword_init: true)

  attr_reader :post, :post_id, :attributes, :thumbnail

  def initialize(post_id:, attributes:, thumbnail: nil)
    @post_id = post_id
    @attributes = attributes
    @thumbnail = thumbnail
  end

  def call
    begin
      @post = find_post

      ActiveRecord::Base.transaction do
        update_post
        update_thumbnail if thumbnail.present?
      end

      Result.new(
        post:,
        message: "更新が完了しました。",
        errors: nil
      )
    rescue ActiveRecord::RecordInvalid => e
      post_errors = e.record.errors.map do |error|
        {
          message: error.full_message,
          path: ["postInput", error.attribute.to_s]
        }
      end

      Result.new(errors: post_errors)
    rescue ActiveRecord::RecordNotFound
      Result.new(
        errors: [
          {
            message: "投稿が見つかりません。",
            path: ["postInput", "id"]
          }
        ]
      )
    rescue => e
      Result.new(
        errors: [
          { message: "更新に失敗しました。#{e.message}" }
        ]
      )
    end
  end

  private
    def find_post
      Post.find(post_id)
    end

    def update_post
      post.update!(attributes)
    end

    def update_thumbnail
      decoded_file = decode_base64_image(thumbnail)
      validate_file_size(decoded_file) if decoded_file.is_a?(Hash) && decoded_file[:io].respond_to?(:size)

      post.thumbnail.attach(decoded_file)
    end

    def validate_file_size(file_data)
      file_size = file_data[:io].size
      if file_size > MAX_FILE_SIZE
        file_data[:io].close if file_data[:io].respond_to?(:close)

        post.errors.add(:thumbnail, "ファイルサイズは2MB以下にしてください")
        raise ActiveRecord::RecordInvalid.new(post)
      end
    end

    def decode_base64_image(base64_string)
      return base64_string unless base64_string.is_a?(String) && base64_string.start_with?('data:')

      match_data = base64_string.match(/\Adata:(.*?);base64,(.+)\z/)
      return base64_string unless match_data

      content_type = match_data[1]
      encoded_data = match_data[2]
      decoded_data = Base64.decode64(encoded_data)

      extension = mime_type_to_extension(content_type)
      create_tempfile_with_data(decoded_data, extension, content_type)
    end

    def mime_type_to_extension(content_type)
      content_type.split('/').last
    end

    def create_tempfile_with_data(decoded_data, extension, content_type)
      temp_file = Tempfile.new(['thumbnail', ".#{extension}"])
      temp_file.binmode
      temp_file.write(decoded_data)
      temp_file.rewind

      {
        io: temp_file,
        filename: "thumbnail.#{extension}",
        content_type: content_type
      }
    end
end
