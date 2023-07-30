class AddUserIdToSchools < ActiveRecord::Migration[7.0]
  def change
    add_reference :schools, :user, null: false, foreign_key: true
  end
end
