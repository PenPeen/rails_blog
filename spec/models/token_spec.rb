require 'rails_helper'

RSpec.describe Token, type: :model do
  describe 'Factory' do
    it 'is valid' do
      expect { FactoryBot.build(:token).save! }.not_to raise_error
    end
  end
end
