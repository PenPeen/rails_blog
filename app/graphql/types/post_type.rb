# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    description '投稿情報'

    field :content, String,
      null: false,
      description: '投稿内容'

    field :created_at, GraphQL::Types::ISO8601DateTime,
      null: false,
      description: '作成日時'

    field :id, ID,
      null: false,
      description: 'ID'

    field :published, Boolean,
      null: false,
      description: '公開状態'

    field :thumbnail_url, String,
      null: true,
      description: 'サムネイルURL'

    field :title, String,
      null: false,
      description: 'タイトル'

    field :updated_at, GraphQL::Types::ISO8601DateTime,
      null: false,
      description: '更新日時'

    field :user, Types::UserType,
      null: false,
      description: '投稿者'

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
