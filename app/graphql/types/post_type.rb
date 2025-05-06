# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :title, String, null: false
    field :content, String, null: false
    field :top_image, String
    field :published, Boolean
    field :thumbnail_url, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :user, Types::UserType, null: false

    def user
      Loaders::AssociationLoader.for(Post, :user).load(object)
    end

    def thumbnail_url
      return nil unless object.thumbnail.attached?

      Loaders::ActiveStorageLoader.for(Post, :thumbnail).load(object.id).then do |thumbnail|
        if Rails.env.production?
          thumbnail.url
        else
          Rails.application.routes.url_helpers.rails_blob_url(
            thumbnail,
            host: Rails.application.routes.default_url_options[:host]
          )
        end
      end
    end
  end
end
