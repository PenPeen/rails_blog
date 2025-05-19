# frozen_string_literal: true

module Types
  class PostInputType < Types::BaseInputObject
    graphql_name "PostInputType"
    description "Attributes for creating a post"

    argument :content, String, required: true
    argument :id, ID, required: true
    argument :published, Boolean, required: true
    argument :title, String, required: true
  end
end
