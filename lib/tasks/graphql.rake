# bundle exec rails graphql:schema:json
require "graphql/rake_task"
GraphQL::RakeTask.new(schema_name: "MyappSchema")
