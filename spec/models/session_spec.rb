require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'Factory' do
    it 'is valid' do
      expect { FactoryBot.build(:session).save! }.not_to raise_error
    end
  end
end
