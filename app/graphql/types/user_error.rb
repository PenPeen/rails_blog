# frozen_string_literal: true

module Types
  class UserError < Types::BaseObject
    description "ユーザー向けエラーメッセージ"

    field :message, String, null: false, description: "エラーメッセージ"
    field :path, [String], null: true, description: "エラーが発生した場所を示すパス"
  end
end
