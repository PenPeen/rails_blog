require 'rails_helper'

RSpec.describe UserImage, type: :model do
  it 'is valid' do
    expect { FactoryBot.build(:user_image).save! }.not_to raise_error
  end
end
