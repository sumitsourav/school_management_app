class School < ApplicationRecord
  belongs_to :user
  has_many :courses, dependent: :destroy
  has_many :students, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
  validates :phone, presence: true, format: { with: /\A\d{10}\z/ }
end
