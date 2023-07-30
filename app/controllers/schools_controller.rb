# app/controllers/schools_controller.rb
class SchoolsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [:new, :create, :edit, :update]

  def index
    @schools = School.all
  end

  def show
    @school = School.find(params[:id])
  end

  def new
    @school = School.new
  end

  def create
    user = User.find_by(email: school_params[:email])
    if user.blank?
      redirect_to new_school_path, alert: "School admin with email: #{school_params[:email]} does not exists"
      return
    end
    new_school_params = school_params.except(:email)
    @school = School.new(new_school_params)
    @school.user_id = user.id
    if @school.save
      redirect_to authenticated_root_path, notice: "School successfully created!"
    else
      redirect_to new_school_path, alert: @school.errors.full_messages.join('\n')
    end
  end

  def edit
    @school = School.find(params[:id])
  end

  def update
    @school = School.find(params[:id])
    if @school.update(school_params)
      redirect_to @school, notice: "School successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @school = School.find(params[:id])
    @school.destroy
    redirect_to schools_path, notice: "School successfully deleted!"
  end

  private

  def school_params
    params.require(:school).permit(:name, :address, :phone, :email)
  end

  def check_admin
    redirect_to root_path, alert: "You don't have permission to create a school!" unless current_user.admin?
  end
end
