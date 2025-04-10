require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Factory' do
    it 'is valid' do
      expect { FactoryBot.build(:post).save! }.not_to raise_error
    end
  end
end
