class RemoveBatchIdFromStudents < ActiveRecord::Migration[7.0]
  def change
    remove_column :students, :batch_id, :integer
  end
end
