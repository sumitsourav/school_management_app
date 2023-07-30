require 'rails_helper'
require 'spec_helper'

RSpec.describe School, type: :model do
  subject(:school) { FactoryBot.build(:school) }

  describe 'validations' do
    it 'validates presence of name' do
      school.name = nil
      expect(school).not_to be_valid
      expect(school.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of address' do
      school.address = nil
      expect(school).not_to be_valid
      expect(school.errors[:address]).to include("can't be blank")
    end

    it 'validates presence of phone' do
      school.phone = nil
      expect(school).not_to be_valid
      expect(school.errors[:phone]).to include("can't be blank")
    end

    it 'validates format of phone' do
      school.phone = '12345'
      expect(school).not_to be_valid
      expect(school.errors[:phone]).to include("is invalid")

      school.phone = 'abcdefghij'
      expect(school).not_to be_valid
      expect(school.errors[:phone]).to include("is invalid")

      school.phone = '12-34-56-78'
      expect(school).not_to be_valid
      expect(school.errors[:phone]).to include("is invalid")

      school.phone = '1234567890'
      expect(school).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:courses).dependent(:destroy) }
    it { should have_many(:students).dependent(:destroy) }
  end

  describe '#full_address' do
    it 'returns the full address of the school' do
      school.name = 'Sample School'
      school.address = '123 Main Street'
      expect(school.address).to eq('123 Main Street')
    end
  end
end
