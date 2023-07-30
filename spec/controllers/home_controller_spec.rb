# spec/controllers/home_controller_spec.rb
require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe '#index' do
    context 'when user is not signed in' do
      it 'redirects to the sign-in page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in as an admin' do
      let(:admin_user) { create(:user, user_type: 'admin') }

      before do
        sign_in(admin_user)
      end

      it 'assigns all schools to @schools' do
        school1 = create(:school)
        school2 = create(:school)
        get :index
        expect(assigns(:schools)).to eq([school1, school2])
      end

      it 'assigns all school admins to @school_admins' do
        school_admin1 = create(:user, user_type: 'school_admin')
        school_admin2 = create(:user, user_type: 'school_admin')
        get :index
        expect(assigns(:school_admins)).to eq([school_admin1, school_admin2])
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when user is signed in as a school admin' do
      let(:school_admin_user) { create(:user, user_type: 'school_admin') }
      let(:school) { create(:school, user: school_admin_user) }
      let(:course1) { create(:course, school: school) }
      let(:course2) { create(:course, school: school) }
      let!(:student1) { create(:user, user_type: 'student') }
      let!(:student2) { create(:user, user_type: 'student') }

      before do
        sign_in(school_admin_user)
      end

      it 'assigns the school to @school' do
        school = create(:school, user: school_admin_user)
        get :index
        expect(assigns(:school)).to eq(school)
      end

      it 'assigns all courses for the school to @courses' do
        course1 = create(:course, school: school)
        course2 = create(:course, school: school)
        get :index
        expect(assigns(:courses)).to eq([course1, course2])
      end

      it 'assigns all students to @students' do
        school = create(:school, user: school_admin_user)
        get :index
        expect(assigns(:students)).to eq([student1, student2])
      end

      it 'renders the index template' do
        school = create(:school, user: school_admin_user)
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when user is signed in as a student' do
      let(:student_user) { create(:user, user_type: 'student') }
      let(:student) { create(:student, user: student_user) }
      let(:school) { create(:school) }
      let(:classmate1) { create(:student, school: school) }
      let(:classmate2) { create(:student, school: school) }

      before do
        sign_in(student_user)
        allow(Student).to receive(:find_by).and_return(student)
        allow(Student).to receive(:where).and_return([classmate1, classmate2])
        allow(School).to receive(:find).and_return(school)
      end

      it 'assigns the student to @student' do
        get :index
        expect(assigns(:student)).to eq(student)
      end

      it 'assigns the school to @school' do
        get :index
        expect(assigns(:school)).to eq(school)
      end

      it 'assigns the classmates to @classmates' do
        get :index
        expect(assigns(:classmates)).to eq([classmate1, classmate2])
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end
end
