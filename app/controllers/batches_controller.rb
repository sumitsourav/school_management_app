# app/controllers/batches_controller.rb
class BatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :check_school_admin, only: [:new, :create, :edit, :update]

  before_action :find_course
  before_action :find_batches, only: :index

  def index
    @batches = @course.batches
  end

  def show
    @batch = @course.batches.find(params[:id])
  end

  def new
    @batch = @course.batches.build
  end

  def create
    @batch = @course.batches.build(batch_params)
    if @batch.save
      redirect_to school_course_batch_path(@course.school, @course, @batch), notice: "Batch successfully created!"
    else
      render :new
    end
  end

  def edit
    @batch = Batch.find(params[:id])
  end

  def update
    @batch = Batch.find(params[:id])
    if @batch.update(batch_params)
      redirect_to school_course_batch_path(@batch.course.school, @batch.course, @batch), notice: "Batch successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @batch = Batch.find(params[:id])
    @batch.destroy
    redirect_to school_course_batches_path(@batch.course.school, @batch.course), notice: "Batch successfully deleted!"
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def batch_params
    params.require(:batch).permit(:name, :start_date, :end_date)
  end

  def check_school_admin
    redirect_to root_path, alert: "You don't have permission to create a batch for this course!" unless current_user.school_admin? || current_user.admin?
  end

  def find_course
    @course = Course.find(params[:course_id])
  end

  def find_batches
    @batches = @course.batches
  end
end
