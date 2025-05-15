# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CurrentUser Query', type: :request do
  describe 'current_user' do
    let(:query_string) do
      <<~GRAPHQL
        query CurrentUser {
          currentUser {
            id
            name
            email
          }
        }
      GRAPHQL
    end

    context 'ログインしている場合' do
      let(:user) { create(:user) }

      it '現在のユーザー情報を返すこと' do
        result = MyappSchema.execute(query_string, context: { current_user: user })
        data = result['data']['currentUser']

        expect(data).to be_present
        expect(data['id']).to eq(user.id.to_s)
        expect(data['name']).to eq(user.name)
        expect(data['email']).to eq(user.email)
      end
    end

    context 'ログインしていない場合' do
      it 'nullを返すこと' do
        result = MyappSchema.execute(query_string, context: { current_user: nil })
        data = result['data']['currentUser']

        expect(data).to be_nil
      end
    end
  end
end
