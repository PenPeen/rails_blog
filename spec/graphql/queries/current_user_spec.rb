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
    let(:current_user) { nil }
    let(:result) { MyappSchema.execute(query_string, context: { current_user: current_user }) }
    let(:data) { result['data'] && result['data']['currentUser'] }

    context 'ログインしている場合' do
      let(:current_user) { create(:user) }

      it '現在のユーザー情報を返すこと' do
        expect(data).to be_present
        expect(data['id']).to eq(current_user.id.to_s)
        expect(data['name']).to eq(current_user.name)
        expect(data['email']).to eq(current_user.email)
      end
    end

    context 'ログインしていない場合' do
      it 'nullを返すこと' do
        expect(data).to be_nil
      end
    end
  end
end
