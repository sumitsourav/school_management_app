class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  self.inheritance_column = :_type_disabled # Disable STI
  has_many :schools, foreign_key: :user_id

  validates :user_type, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password, length: { minimum: 6 }, allow_blank: true, on: :update

  def admin?
    if user_type == 'admin'
      return true
    else
      return false
    end
  end

  def school_admin?
    if user_type == 'school_admin'
      return true
    else
      return false
    end
  end

  def student?
    if user_type == 'student'
      return true
    else
      return false
    end
  end
end
