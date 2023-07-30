# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    if user_signed_in?
      if current_user.admin?
        @schools = School.all
        @school_admins = User.where(user_type: 'school_admin')
      elsif current_user.school_admin?
        @school = School.find_by(user_id: current_user.id)
        @courses = @school.courses
        @students = User.where(user_type: 'student')
      elsif current_user.student?
        @student = Student.find_by(user_id: current_user.id)
        @school = School.find(@student.school_id)
        @classmates = Student.where(school_id: @student.school_id)
      end
    end
  end
end
