class AddEmailAndUserIdToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :email, :string
    add_column :students, :user_id, :integer

    add_index :students, :email, unique: true
    add_index :students, :user_id, unique: true
  end
end
