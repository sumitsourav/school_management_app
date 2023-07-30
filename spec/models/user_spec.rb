require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  describe '#admin?' do
    context 'when user_type is "admin"' do
      before { user.user_type = 'admin' }

      it 'returns true' do
        expect(user.admin?).to be true
      end
    end

    context 'when user_type is not "admin"' do
      before { user.user_type = 'school_admin' }

      it 'returns false' do
        expect(user.admin?).to be false
      end
    end
  end

  describe '#school_admin?' do
    context 'when user_type is "school_admin"' do
      before { user.user_type = 'school_admin' }

      it 'returns true' do
        expect(user.school_admin?).to be true
      end
    end

    context 'when user_type is not "school_admin"' do
      before { user.user_type = 'student' }

      it 'returns false' do
        expect(user.school_admin?).to be false
      end
    end
  end

  describe '#student?' do
    context 'when user_type is "student"' do
      before { user.user_type = 'student' }

      it 'returns true' do
        expect(user.student?).to be true
      end
    end

    context 'when user_type is not "student"' do
      before { user.user_type = 'school_admin' }

      it 'returns false' do
        expect(user.student?).to be false
      end
    end
  end
end
