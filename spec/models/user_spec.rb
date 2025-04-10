require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    it 'is valid' do
      expect { FactoryBot.build(:user).save! }.not_to raise_error
    end
  end
end
