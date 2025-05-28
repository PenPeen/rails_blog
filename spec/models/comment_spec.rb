require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Factory' do
    it 'is valid' do
      expect { FactoryBot.build(:comment).save! }.not_to raise_error
    end
  end
end
