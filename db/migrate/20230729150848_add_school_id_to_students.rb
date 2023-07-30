class AddSchoolIdToStudents < ActiveRecord::Migration[7.0]
  def change
    add_reference :students, :school, null: false, foreign_key: true
  end
end
