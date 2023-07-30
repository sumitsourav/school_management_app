require 'rails_helper'
require 'spec_helper'

RSpec.describe Enrollment, type: :model do
  subject(:enrollment) { FactoryBot.build(:enrollment) }

  describe 'validations' do
    it 'validates presence of status' do
      enrollment.status = nil
      expect(enrollment).not_to be_valid
      expect(enrollment.errors[:status]).to include("can't be blank")
    end

    it 'validates inclusion of status in ["pending", "approved", "denied"]' do
      enrollment.status = 'invalid_status'
      expect(enrollment).not_to be_valid
      expect(enrollment.errors[:status]).to include("is not included in the list")

      enrollment.status = 'approved'
      expect(enrollment).to be_valid
    end

    context 'when status is "approved"' do
      let!(:existing_enrollment) { FactoryBot.create(:enrollment, status: 'approved') }

      it 'validates uniqueness of student within the same batch' do
        enrollment.student = existing_enrollment.student
        enrollment.batch = existing_enrollment.batch
        enrollment.status = 'approved'

        expect(enrollment).not_to be_valid
        expect(enrollment.errors[:student_id]).to include("is already enrolled in this batch")
      end
    end

    context 'when status is not "approved"' do
      it 'does not apply uniqueness validation' do
        existing_enrollment = FactoryBot.create(:enrollment, status: 'approved')
        enrollment.student = existing_enrollment.student
        enrollment.batch = existing_enrollment.batch
        enrollment.status = 'pending'

        expect(enrollment).to be_valid
      end
    end
  end

  describe 'associations' do
    it 'belongs to a student' do
      expect(enrollment).to belong_to(:student)
    end

    it 'belongs to a batch' do
      expect(enrollment).to belong_to(:batch)
    end
  end
end
