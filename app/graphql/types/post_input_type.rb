# frozen_string_literal: true

module Types
  class PostInputType < Types::BaseInputObject
    graphql_name "PostInputType"
    description "Attributes for creating a post"

    argument :content, String,
      required: true,
      description: "記事内容"

    argument :id, ID,
      required: true,
      description: "記事ID"

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
