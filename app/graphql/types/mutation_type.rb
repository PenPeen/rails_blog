# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'MutationType'

    field :login, mutation: Mutations::Auth::LoginMutation
    field :logout, mutation: Mutations::Auth::LogoutMutation
    field :confirm_registration, mutation: Mutations::Auth::ConfirmRegistrationMutation

    field :create_post, mutation: Mutations::Post::CreatePostMutation
    field :update_post, mutation: Mutations::Post::UpdatePostMutation
    field :delete_post, mutation: Mutations::Post::DeletePostMutation

    field :create_user, mutation: Mutations::User::CreateUserMutation
    field :update_user_profile, mutation: Mutations::User::UpdateUserProfileMutation
  end
end
