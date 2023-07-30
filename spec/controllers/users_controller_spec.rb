require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:admin_user) { create(:user, user_type: 'admin') }

  describe 'GET #index' do
    it 'assigns all users to @users' do
      user1 = create(:user, user_type: 'admin')
      user2 = create(:user, user_type: 'admin')
      sign_in user1

      get :index
      expect(assigns(:users)).to eq([user1, user2])
    end

    it 'renders the index template' do
      sign_in(admin_user)

      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user to @user' do
      user = create(:user, user_type: 'admin')
      sign_in(admin_user)

      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the show template' do
      user = create(:user, user_type: 'admin')
      sign_in(admin_user)

      get :show, params: { id: user.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new user to @user' do
      sign_in(admin_user)

      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new template' do
      sign_in(admin_user)

      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new user' do
        sign_in(admin_user)

        expect {
          post :create, params: { user: attributes_for(:user, user_type: 'admin') }
        }.to change(User, :count).by(1)
      end

      it 'redirects to the root path' do
        sign_in(admin_user)

        post :create, params: { user: attributes_for(:user, user_type: 'admin') }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new user' do
        sign_in(admin_user)

        expect {
          post :create, params: { user: attributes_for(:user, email: nil) }
        }.not_to change(User, :count)
      end

      it 'renders the new template' do
        sign_in(admin_user)

        post :create, params: { user: attributes_for(:user, email: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #list_school_admins' do
    let!(:school_admin1) { create(:user, user_type: 'school_admin') }
    let!(:school_admin2) { create(:user, user_type: 'school_admin') }

    it 'assigns all school admins to @school_admins' do
      sign_in(admin_user)

      get :list_school_admins
      expect(assigns(:school_admins)).to eq([school_admin1, school_admin2])
    end

    it 'renders the list_school_admins template' do
      sign_in(admin_user)

      get :list_school_admins
      expect(response).to render_template(:list_school_admins)
    end
  end

  describe 'GET #new_school_admin' do
    it 'assigns all schools to @schools' do
      sign_in(admin_user)
      school1 = create(:school)
      school2 = create(:school)

      get :new_school_admin
      expect(assigns(:schools)).to eq([school1, school2])
    end

    it 'assigns a new user to @user' do
      sign_in(admin_user)

      get :new_school_admin
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new_school_admin template' do
      sign_in(admin_user)

      get :new_school_admin
      expect(response).to render_template(:new_school_admin)
    end
  end

  describe 'POST #create_school_admin' do
    let(:school) { create(:school) }

    context 'with valid params' do
      it 'creates a new user as a school admin' do
        sign_in(admin_user)

        expect {
          post :create_school_admin, params: {
            user: attributes_for(:user, user_type: 'school_admin', school_id: school.id)
          }
        }.to change(User, :count).by(2)
      end

      it 'assigns the user as the admin of the selected school' do
        sign_in(admin_user)

        post :create_school_admin, params: {
          user: attributes_for(:user, user_type: 'school_admin', school_id: school.id)
        }

        expect(school.reload.user_id).to eq(User.last.id)
      end

      it 'redirects to the authenticated_root_path' do
        sign_in(admin_user)

        post :create_school_admin, params: {
          user: attributes_for(:user, user_type: 'school_admin', school_id: school.id)
        }
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new user' do
        sign_in(admin_user)
      
        expect { 
            post :create_school_admin, params: {
              user: attributes_for(:user, user_type: 'school_admin')
            }
          }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
