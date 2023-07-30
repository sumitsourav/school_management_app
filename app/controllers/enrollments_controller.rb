# app/controllers/enrollments_controller.rb

class EnrollmentsController < ApplicationController
  before_action :set_batch, only: [:new, :create, :index]


  def index
    @school = School.find(params[:school_id])
    @enrollment_requests = Enrollment.where(batch_id: params[:batch_id], status: 'pending')
  end

  def new
    @batch = Batch.find(params[:batch_id])
    @school = School.find(params[:school_id])
    @enrollment = Enrollment.new
    @current_user = current_user
    @students = Student.where(school_id: params[:school_id])
    if current_user.student?
      @student = Student.find_by(user_id: current_user.id)
    end
  end

  def create
    @batch = Batch.find(params[:batch_id])

    enrollment_for_student = @batch.enrollments.find_by(student_id: params[:enrollment][:student_id])

    if enrollment_for_student.present? && enrollment_for_student.status == "approved"
      redirect_to new_school_course_batch_enrollment_path, alert: "Student already enrolled in this batch"
      return
    elsif enrollment_for_student.present? && enrollment_for_student.status == "pending" && ( current_user.school_admin? || current_user.admin? )
      redirect_to new_school_course_batch_enrollment_path, alert: "Student has already raised a request: please look in Enrollment Requests"
      return
    elsif enrollment_for_student.present? && enrollment_for_student.status == "pending" && current_user.student?
      redirect_to new_school_course_batch_enrollment_path, alert: "You have already raised a request for this batch"
      return
    end

    if enrollment_for_student.present? && enrollment_for_student.status == "denied" && current_user.student?
      enrollment_for_student.update(status: 'pending')
      redirect_to new_school_course_batch_enrollment_path, notice: "Enrollment request raised successfully!"
      return
    elsif enrollment_for_student.present? && enrollment_for_student.status == "denied" && ( current_user.admin? || current_user.school_admin? )
      enrollment_for_student.update(status: 'approved')
      redirect_to new_school_course_batch_enrollment_path, notice: "Student enrolled successfully!"
      return
    end

    @enrollment = @batch.enrollments.build(enrollment_params)

    @enrollment.status = 'approved' if current_user.admin? || current_user.school_admin?

    @enrollment.status = 'pending' if current_user.student?

    if @enrollment.save
      redirect_to school_course_path(id: params[:course_id], school_id: params[:school_id]), notice: current_user.student? ? "Enrollment request raised successfully!" : "Student enrolled successfully!"
    else
      redirect_to new_school_course_batch_enrollment_path, alert: @enrollment.errors.full_messages.join('\n')
    end
  end

  def approval
    enrollment_request = Enrollment.find(params[:id])
    id = enrollment_request.batch.course_id
    school_id = enrollment_request.batch.course.school_id
    if enrollment_request.update(status: 'approved')
      redirect_to school_course_path(id: id, school_id: school_id), notice: 'Enrollment request approved successfully!'
    else
      redirect_to school_course_path(id: id, school_id: school_id), alert: 'Failed to approve enrollment request!'
    end
  end

  def decline
    enrollment_request = Enrollment.find(params[:id])
    id = enrollment_request.batch.course_id
    school_id = enrollment_request.batch.course.school_id
    if enrollment_request.update(status: 'denied')
      redirect_to school_course_path(id: id, school_id: school_id), notice: 'Enrollment request declined successfully!'
    else
      redirect_to school_course_path(id: id, school_id: school_id), alert: 'Failed to decline enrollment request!'
    end
  end

  private

  def set_batch
    @batch = Batch.find(params[:batch_id])
  end

  def enrollment_params
    params.require(:enrollment).permit(:student_id, :status)
  end

  def available_students_for_batch
    @batch.students.where.not(id: @batch.enrollments.pluck(:student_id))
  end
end
