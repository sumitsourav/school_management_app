# app/controllers/courses_controller.rb
class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_school
  before_action :check_school_admin, only: [:new, :create, :edit, :update]

  def index
    @courses = @school.courses
  end

  def show
    @course = @school.courses.find(params[:id])
    @students = @school.students
    @student = Student.find_by(user_id: current_user.id)
  end

  def new
    @course = @school.courses.build
  end

  def create
    @course = @school.courses.build(course_params)
    if @course.save
      redirect_to school_course_path(@school, @course), notice: "Course successfully created!"
    else
      render :new
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update(course_params)
      redirect_to school_course_path(@course.school, @course), notice: "Course successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    redirect_to school_courses_path(@course.school), notice: "Course successfully deleted!"
  end


  private

  def set_school
    @school = School.find(params[:school_id])
  end

  def course_params
    params.require(:course).permit(:name, :description)
  end

  def check_school_admin
    redirect_to root_path, alert: "You don't have permission to create a course for this school!" unless current_user.school_admin? || current_user.admin?
  end

  def find_school
    @school = School.find(params[:school_id])
  end

  def find_course
    @course = @school.courses.find(params[:id])
  end
end
