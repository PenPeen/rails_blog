# frozen_string_literal: true

module Resolvers
  class NodeResolver < GraphQL::Schema::Resolver
    type Types::NodeType, null: true
    description "Fetches an object given its ID."

    argument :id, ID, required: true, description: "ID of the object."

    def resolve(id:)
      context.schema.object_from_id(id, context)
    end
  end
end
