# app/controllers/users_controller.rb
class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "User successfully created!"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_path, notice: "User successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: "User successfully deleted!"
  end

  def list_school_admins
    @school_admins = User.where(user_type: 'school_admin')
  end

  def new_school_admin
    @schools = School.all
    @user = User.new
  end

  def create_school_admin
    @schools = School.all
    @school = School.find(school_admin_params[:school_id])
    user_params = school_admin_params.except(:school_id)
    @user = User.new(user_params.merge(user_type: 'school_admin'))
    if @user.save
      @school.update(user_id: @user.id)
      redirect_to authenticated_root_path, notice: "School admin created successfully!"
    else
      redirect_to new_school_admin_path, alert: @user.errors.full_messages.join("\n")
    end
  end

  def school_admin_section
    @school_admin_schools = School.where(user_id: current_user.id)
  end

  private

  def user_params
    params.require(:user).permit(:type, :email, :password, :password_confirmation, :user_type)
  end

  def school_admin_params
    params.require(:user).permit(:email, :password, :password_confirmation, :school_id)
  end
end
