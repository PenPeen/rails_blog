# frozen_string_literal: true

class UserProfileService
  MAX_FILE_SIZE = 2.megabytes

  Result = Struct.new(:user, :message, :errors, keyword_init: true)

  attr_reader :user, :name, :profile

  def initialize(user:, name:, profile: nil)
    @user = user
    @name = name
    @profile = profile
  end

  def call
    begin
      updated_user = ActiveRecord::Base.transaction do
        update_user_name
        update_profile_image if profile.present?
        user
      end

      Result.new(
        user: updated_user,
        message: "プロフィールが正常に更新されました。",
        errors: nil
      )
    rescue ActiveRecord::RecordInvalid => e
      user_errors = e.record.errors.map do |error|
        {
          message: error.full_message,
          path: ["userProfileInput", error.attribute.to_s]
        }
      end

      Result.new(user: nil, message: nil, errors: user_errors)
    rescue StandardError => e
      Result.new(
        user: nil,
        message: nil,
        errors: [
          { message: "予期せぬエラーが発生しました。#{e.message}" }
        ]
      )
    end
  end

  private

    def update_user_name
      user.update!(name: name)
    end

    def update_profile_image
      user.create_user_image! unless user.user_image.present?

      decoded_file = decode_base64_image(profile)
      validate_file_size(decoded_file) if decoded_file.is_a?(Hash) && decoded_file[:io].respond_to?(:size)

      user.user_image.profile.attach(decoded_file)
    end

    def validate_file_size(file_data)
      file_size = file_data[:io].size
      if file_size > MAX_FILE_SIZE
        file_data[:io].close if file_data[:io].respond_to?(:close)

        user.errors.add(:profile, "ファイルサイズは2MB以下にしてください")
        raise ActiveRecord::RecordInvalid.new(user)
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
      temp_file = Tempfile.new(['profile', ".#{extension}"])
      temp_file.binmode
      temp_file.write(decoded_data)
      temp_file.rewind

      {
        io: temp_file,
        filename: "profile.#{extension}",
        content_type: content_type
      }
    end
end
