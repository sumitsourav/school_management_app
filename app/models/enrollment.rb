class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :batch

  validates :status, presence: true, inclusion: { in: ['pending', 'approved', 'denied'] }
  validate :student_unique_per_batch_when_approved

  private

  def student_unique_per_batch_when_approved
    # Only apply the uniqueness validation when the status is 'approved'
    if status == 'approved' && Enrollment.exists?(student_id: student_id, batch_id: batch_id, status: 'approved')
      errors.add(:student_id, "is already enrolled in this batch")
    end
  end
end
