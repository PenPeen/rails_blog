# frozen_string_literal: true

module Types
  class UserInputType < Types::BaseInputObject
    graphql_name "UserInputType"
    description "Attributes for creating a user"

    argument :name, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
  end
end
