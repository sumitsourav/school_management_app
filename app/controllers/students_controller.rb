# app/controllers/students_controller.rb
class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_batch
  before_action :check_school_admin, only: [:new, :create]

  def index
    @students = @batch.students
  end

  def show
    @student = @batch.students.find(params[:id])
  end

  def new
    @student = @batch.students.build
  end

  def create
    @student = @batch.students.build(student_params)
    if @student.save
      redirect_to batch_student_path(@batch, @student), notice: "Student successfully created!"
    else
      render :new
    end
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    if @student.update(student_params)
      redirect_to batch_student_path(@student.batch, @student), notice: "Student successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to batch_students_path(@student.batch), notice: "Student successfully deleted!"
  end

  private

  def set_batch
    @batch = Batch.find(params[:batch_id])
  end

  def student_params
    params.require(:student).permit(:name, :roll_number)
  end

  def check_school_admin
    redirect_to root_path, alert: "You don't have permission to add a student to this batch!" unless current_user.school_admin? || current_user.admin?
  end
end
