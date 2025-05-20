# frozen_string_literal: true

# Usage
=begin
mutation UpdateUserProfile($input: UpdateUserProfileMutationInput!) {
  updateUserProfile(input: $input) {
    user {
      id
      name
      email
      user_image {
        profile
      }
    }
    message
    errors {
      message
      path
    }
  }
}
=end

module Mutations
  class UpdateUserProfileMutation < LoginRequiredMutation
    argument :user_profile_input, Types::UserProfileInputType, required: true

    field :message, String, null: true
    field :user, Types::UserType, null: true
    field :errors, [Types::UserError], null: true

    def resolve(user_profile_input:)
      user = context[:current_user]

      service = UserProfileService.new(
        user: user,
        name: user_profile_input.name,
        profile: user_profile_input.profile
      )

      begin
        updated_user = service.call

        {
          user: updated_user,
          message: "プロフィールが正常に更新されました。",
        }
      rescue ActiveRecord::RecordInvalid => e
        user_errors = e.record.errors.map do |error|
          {
            message: error.full_message,
            path: ["userProfileInput", error.attribute.to_s]
          }
        end

        { errors: user_errors }
      rescue StandardError => e
        {
          errors: [
            { message: "予期せぬエラーが発生しました。#{e.message}" }
          ]
        }
      end
    end
  end
end
