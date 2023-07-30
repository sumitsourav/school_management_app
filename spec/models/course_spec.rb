require 'rails_helper'
require 'spec_helper'

RSpec.describe Course, type: :model do
  subject(:course) { FactoryBot.build(:course) }

  describe 'validations' do
    it 'validates presence of name' do
      course.name = nil
      expect(course).not_to be_valid
      expect(course.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of description' do
      course.description = nil
      expect(course).not_to be_valid
      expect(course.errors[:description]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a school' do
      expect(course).to belong_to(:school)
    end

    it 'has many batches and dependent destroy' do
      expect(course).to have_many(:batches).dependent(:destroy)
    end
  end
end
