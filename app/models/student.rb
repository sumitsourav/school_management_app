class Student < ApplicationRecord
  belongs_to :school
  belongs_to :user

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :roll_number, presence: true, uniqueness: { scope: :school_id }
end
