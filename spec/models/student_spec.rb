require 'rails_helper'
require 'spec_helper'

RSpec.describe Student, type: :model do
  subject(:student) { FactoryBot.build(:student) }

  describe 'validations' do
    it 'validates presence of name' do
      student.name = nil
      expect(student).not_to be_valid
      expect(student.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of email' do
      student.email = nil
      expect(student).not_to be_valid
      expect(student.errors[:email]).to include("can't be blank")
    end

    it 'validates uniqueness of email' do
      existing_student = FactoryBot.create(:student)
      student.email = existing_student.email
      expect(student).not_to be_valid
      expect(student.errors[:email]).to include("has already been taken")
    end

    it 'validates presence of roll_number' do
      student.roll_number = nil
      expect(student).not_to be_valid
      expect(student.errors[:roll_number]).to include("can't be blank")
    end

    it 'validates uniqueness of roll_number within the same school' do
      existing_student = FactoryBot.create(:student)
      student.roll_number = existing_student.roll_number
      student.school = existing_student.school
      expect(student).not_to be_valid
      expect(student.errors[:roll_number]).to include("has already been taken")
    end
  end

  describe 'associations' do
    it 'belongs to a school' do
      expect(student).to belong_to(:school)
    end

    it 'belongs to a user' do
      expect(student).to belong_to(:user)
    end
  end
end
