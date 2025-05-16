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
  }
}
=end

module Mutations
  class UpdateUserProfileMutation < LoginRequiredMutation
    argument :user_profile_input, Types::UserProfileInputType, required: true

    field :user, Types::UserType, null: false
    field :message, String, null: false

    def resolve(user_profile_input:)
      user = context[:current_user]

      service = UserProfileService.new(
        user: user,
        name: user_profile_input.name,
        profile: user_profile_input.profile
      )

      updated_user = service.call

      {
        user: updated_user,
        message: "プロフィールが正常に更新されました。"
      }
    rescue ActiveRecord::RecordInvalid => e
      raise GraphQL::ExecutionError.new(
        "プロフィール更新に失敗しました。\n#{e.record.errors.full_messages.join(', ')}"
      )
    rescue StandardError => e
      raise GraphQL::ExecutionError.new(
        "予期せぬエラーが発生しました。\n#{e.message}"
      )
    end
  end
end
