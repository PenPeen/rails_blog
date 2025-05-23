# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::LoginMutation
    field :logout, mutation: Mutations::LogoutMutation

    field :confirm_registration, mutation: Mutations::ConfirmRegistrationMutation
    field :create_post, mutation: Mutations::CreatePostMutation
    field :create_user, mutation: Mutations::CreateUserMutation

    field :update_post, mutation: Mutations::UpdatePostMutation
    field :update_user_profile, mutation: Mutations::UpdateUserProfileMutation

    field :delete_post, mutation: Mutations::DeletePostMutation
  end
end
