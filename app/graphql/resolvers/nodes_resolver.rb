# frozen_string_literal: true

module Resolvers
  class NodesResolver < GraphQL::Schema::Resolver
    type [Types::NodeType, null: true], null: true
    description "Fetches a list of objects given a list of IDs."

    argument :ids, [ID], required: true, description: "IDs of the objects."

    def resolve(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end
  end
end
