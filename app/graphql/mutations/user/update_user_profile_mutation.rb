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

module Mutations::User
  class UpdateUserProfileMutation < Mutations::LoginRequiredMutation
    description 'ユーザープロフィール更新'

    argument :user_profile_input, Types::UserProfileInputType,
      required: true,
      description: 'ユーザープロフィール情報'

    field :errors,
      [Types::UserError],
      null: true,
      description: 'エラー情報'

    field :message, String,
      null: true,
      description: 'メッセージ'

    field :user, Types::UserType,
      null: true,
      description: '更新されたユーザー'

    def resolve(user_profile_input:)
      service = UserProfileService.new(
        user: context[:current_user],
        name: user_profile_input.name,
        profile: user_profile_input.profile
      )

      result = service.call

      {
        user: result.user,
        message: result.message,
        errors: result.errors
      }
    end
  end
end
