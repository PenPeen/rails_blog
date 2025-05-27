# frozen_string_literal: true

module Types
  class UserError < Types::BaseObject
    description 'ユーザー操作によって生成されたエラー情報'

    field :message, String,
      null: false,
      description: 'エラーメッセージ'

    field :path, [String],
      null: true,
      description: 'エラーの発生場所'
  end
end
