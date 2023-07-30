require 'rails_helper'
require 'spec_helper'

RSpec.describe Batch, type: :model do
  subject(:batch) { FactoryBot.build(:batch) }

  describe 'validations' do
    it 'validates presence of name' do
      batch.name = nil
      expect(batch).not_to be_valid
      expect(batch.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of start_date' do
      batch.start_date = nil
      expect(batch).not_to be_valid
      expect(batch.errors[:start_date]).to include("can't be blank")
    end

    it 'validates presence of end_date' do
      batch.end_date = nil
      expect(batch).not_to be_valid
      expect(batch.errors[:end_date]).to include("can't be blank")
    end

    it 'validates end_date is after start_date' do
      batch.start_date = Date.today
      batch.end_date = Date.today - 1
      expect(batch).not_to be_valid
      expect(batch.errors[:end_date]).to include("must be after the start date")

      batch.end_date = Date.today + 1
      expect(batch).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a course' do
      expect(batch).to belong_to(:course)
    end

    it 'has many enrollments' do
      expect(batch).to have_many(:enrollments)
    end
  end
end
