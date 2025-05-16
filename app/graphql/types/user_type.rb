# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :email, String, null: false
    field :id, ID, null: false
    field :name, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :posts, [Types::PostType], null: true
    field :user_image, Types::UserImageType, null: true

    def posts
      Loaders::AssociationLoader.for(User, :posts).load(object)
    end

    def user_image
      Loaders::AssociationLoader.for(User, :user_image).load(object)
    end
  end
end
