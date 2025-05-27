# frozen_string_literal: true

module Types
  class CreatePostInputType < Types::BaseInputObject
    graphql_name "CreatePostInputType"
    description "Attributes for creating a post"

    argument :content, String,
      required: true,
      description: "記事内容"

    argument :published, Boolean,
      required: true,
      description: "公開状態"

    argument :thumbnail, String,
      required: false,
      description: "Base64エンコードされたサムネイル画像"

    argument :title, String,
      required: true,
      description: "記事タイトル"
  end
end
