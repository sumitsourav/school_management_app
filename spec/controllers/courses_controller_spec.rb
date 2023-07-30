require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  describe 'GET #index' do
    before { sign_in FactoryBot.create(:user, :school_admin) }

    it 'assigns @courses with all courses for the school' do
      school = FactoryBot.create(:school)
      course1 = FactoryBot.create(:course, school: school)
      course2 = FactoryBot.create(:course, school: school)
      
      get :index, params: { school_id: school.id }
      
      expect(assigns(:courses)).to eq([course1, course2])
    end
    
    it 'renders the index template' do
      school = FactoryBot.create(:school)
      get :index, params: { school_id: school.id }
      
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { sign_in FactoryBot.create(:user, :admin) }

    it 'assigns @course and @students' do
      school = FactoryBot.create(:school)
      course = FactoryBot.create(:course, school: school)
      student1 = FactoryBot.create(:student, school: school)
      student2 = FactoryBot.create(:student, school: school)
      
      get :show, params: { school_id: school.id, id: course.id }
      
      expect(assigns(:course)).to eq(course)
      expect(assigns(:students)).to eq([student1, student2])
    end
    
    it 'assigns @student if the current user is a student' do
      school = FactoryBot.create(:school)
      course = FactoryBot.create(:course, school: school)
      student = FactoryBot.create(:student, school: school)
      sign_in student.user
      
      get :show, params: { school_id: school.id, id: course.id }
      
      expect(assigns(:student)).to eq(student)
    end

    it 'renders the show template' do
      school = FactoryBot.create(:school)
      course = FactoryBot.create(:course, school: school)
      
      get :show, params: { school_id: school.id, id: course.id }
      
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Course to @course' do
      school = FactoryBot.create(:school)
      sign_in FactoryBot.create(:user, :school_admin)
      
      get :new, params: { school_id: school.id }
      
      expect(assigns(:course)).to be_a_new(Course)
    end
    
    it 'renders the new template' do
      school = FactoryBot.create(:school)
      sign_in FactoryBot.create(:user, :school_admin)
      
      get :new, params: { school_id: school.id }
      
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:school) { FactoryBot.create(:school) }
    let(:valid_params) { { name: 'Mathematics', description: 'A course about numbers'} }
    
    context 'when user is a school admin' do
      before { sign_in FactoryBot.create(:user, :school_admin) }
      
      it 'creates a new course with valid params' do
        expect {
          post :create, params: { school_id: school.id, course: valid_params }
        }.to change(Course, :count).by(1)
      end

      it 'redirects to the created course' do
        post :create, params: { school_id: school.id, course: valid_params }
        
        expect(response).to redirect_to(school_course_path(assigns(:school), assigns(:course)))
      end

      it 'renders the new template with invalid params' do
        post :create, params: { school_id: school.id, course: { name: nil, description: 'A course about numbers'} }
        
        expect(response).to render_template(:new)
      end
    end

    context 'when user is not a school admin' do
      before { sign_in FactoryBot.create(:user, :student) }
      
      it 'does not create a new course' do
        expect {
          post :create, params: { school_id: school.id, course: valid_params }
        }.to_not change(Course, :count)
      end

      it 'redirects to the root path' do
        post :create, params: {school_id: school.id,  course: valid_params }
        
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested course to @course' do
      school = FactoryBot.create(:school)
      course = FactoryBot.create(:course, school: school)
      sign_in FactoryBot.create(:user, :school_admin)
      
      get :edit, params: { school_id: school.id, id: course.id }
      
      expect(assigns(:course)).to eq(course)
    end
    
    it 'renders the edit template' do
      school = FactoryBot.create(:school)
      course = FactoryBot.create(:course, school: school)
      sign_in FactoryBot.create(:user, :school_admin)
      
      get :edit, params: { school_id: school.id, id: course.id }
      
      expect(response).to render_template(:edit)
    end
  end
end
