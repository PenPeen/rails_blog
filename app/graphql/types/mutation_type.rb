# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::LoginMutation
    field :logout, mutation: Mutations::LogoutMutation

    field :create_user, mutation: Mutations::CreateUserMutation
    field :update_user_profile, mutation: Mutations::UpdateUserProfileMutation
    field :confirm_registration, mutation: Mutations::ConfirmRegistrationMutation
  end
end
