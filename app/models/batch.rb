class Batch < ApplicationRecord
  belongs_to :course
  has_many :students, dependent: :destroy
  has_many :enrollments

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?
    errors.add(:end_date, "must be after the start date") if end_date < start_date
  end
end
