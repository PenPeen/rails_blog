# frozen_string_literal: true

module Types
  class PostInputType < Types::BaseInputObject
    graphql_name "PostInputType"
    description "Attributes for creating a post"

    argument :id, ID, required: true
    argument :title, String, required: true
    argument :content, String, required: true
    argument :published, Boolean, required: true
  end
end
