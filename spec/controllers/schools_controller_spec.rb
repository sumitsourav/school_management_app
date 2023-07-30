# spec/controllers/schools_controller_spec.rb
require 'rails_helper'

RSpec.describe SchoolsController, type: :controller do
  describe 'GET #index' do
    before { sign_in FactoryBot.create(:user, :admin) }

    it 'assigns @schools with all schools' do
      school1 = create(:school)
      school2 = create(:school)
      get :index
      expect(assigns(:schools)).to eq([school1, school2])
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { sign_in FactoryBot.create(:user, :admin) }

    it 'assigns @school with the requested school' do
      school = FactoryBot.create(:school)
      get :show, params: { id: school.id }
      expect(assigns(:school)).to eq(school)
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    context 'when the user is admin' do
      before { sign_in FactoryBot.create(:user, :admin) }

      it 'assigns a new School to @school' do
        get :new
        expect(assigns(:school)).to be_a_new(School)
        expect(response).to render_template(:new)
      end
    end

    context 'when the user is not admin' do
      before { sign_in FactoryBot.create(:user, :student) }

      it 'redirects to root path' do
        get :new
        expect(response).to redirect_to(root_path)
      end

      it 'shows an alert' do
        get :new
        expect(flash[:alert]).to eq("You don't have permission to create a school!")
      end
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { FactoryBot.attributes_for(:school, email: User.all.first.email) }
    let(:invalid_attributes) { FactoryBot.attributes_for(:school, email: "123@gmail.com") }

    context 'when the user is admin' do
      before { sign_in FactoryBot.create(:user, :admin) }

      context 'with valid attributes' do
        it 'creates a new school' do
          expect {
            post :create, params: { school: valid_attributes }
          }.to change(School, :count).by(1)

          expect(response).to redirect_to(authenticated_root_path)
          expect(flash[:notice]).to eq('School successfully created!')
        end
      end

      context 'with invalid attributes' do
        it 'does not create a new school' do
          expect {
            post :create, params: { school: invalid_attributes }
          }.not_to change(School, :count)

          expect(response).to redirect_to(new_school_path)
          expect(flash[:alert]).to include("School admin with email: 123@gmail.com does not exists")
        end
      end
    end

    context 'when the user is not admin' do
      before { sign_in FactoryBot.create(:user, :student) }

      it 'does not create a new school' do
        expect {
          post :create, params: { school: valid_attributes }
        }.not_to change(School, :count)

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'when the user is admin' do
      before { sign_in FactoryBot.create(:user, :admin) }

      it 'assigns the requested school to @school' do
        school = FactoryBot.create(:school)
        get :edit, params: { id: school.id }
        expect(assigns(:school)).to eq(school)
        expect(response).to render_template(:edit)
      end
    end

    context 'when the user is not admin' do
      before { sign_in FactoryBot.create(:user, :student) }

      it 'redirects to root path' do
        school = FactoryBot.create(:school)
        get :edit, params: { id: school.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:school) { FactoryBot.create(:school) }
    let(:valid_attributes) { { name: 'New Name' } }
    let(:invalid_attributes) { { name: nil } }

    context 'when the user is admin' do
      before { sign_in FactoryBot.create(:user, :admin) }

      context 'with valid attributes' do
        it 'updates the school' do
          patch :update, params: { id: school.id, school: valid_attributes }
          school.reload
          expect(school.name).to eq('New Name')
          expect(response).to redirect_to(school)
          expect(flash[:notice]).to eq('School successfully updated!')
        end
      end

      context 'with invalid attributes' do
        it 'does not update the school' do
          patch :update, params: { id: school.id, school: invalid_attributes }
          school.reload
          expect(school.name).not_to be_nil
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when the user is not admin' do
      before { sign_in FactoryBot.create(:user, :student) }

      it 'does not update the school' do
        patch :update, params: { id: school.id, school: valid_attributes }
        school.reload
        expect(school.name).not_to eq('New Name')
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
