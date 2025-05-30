# frozen_string_literal: true

module Types
  class BaseConnection < Types::BaseObject
    # add `nodes` and `pageInfo` fields, as well as `edge_type(...)` and `node_nullable(...)` overrides
    include GraphQL::Types::Relay::ConnectionBehaviors

    node_nullable(false)
    edges_nullable(false)
    edge_nullable(false)

    field :total_count, Integer, null: false

    def total_count
      object.items.length
    end
  end
end
