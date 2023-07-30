# spec/factories.rb

# Define the factory for User
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }

    trait :admin do
      user_type { 'admin' }
    end

    trait :school_admin do
      user_type { 'school_admin' }
    end

    trait :student do
      user_type { 'student' }
    end
  end
end

# Define the factory for School
FactoryBot.define do
  factory :school do
    name { Faker::University.name }
    address { Faker::Address.full_address }
    phone { '1234567890' }
    association :user, factory: :user, user_type: 'school_admin'
  end
end

# Define the factory for Course
FactoryBot.define do
  factory :course do
    name { Faker::Educator.subject }
    description { Faker::Lorem.sentence }
    association :school
  end
end

# Define the factory for Student
FactoryBot.define do
  factory :student do
    name { Faker::Name.name }
    roll_number { Faker::Number.unique.number(digits: 3) }
    email { Faker::Internet.email }
    association :school
    association :user, factory: :user, user_type: 'student'
  end

  factory :batch do
    name { Faker::Lorem.word }
    start_date { Faker::Date.between(from: 1.year.ago, to: Date.today) }

    # Create a valid Course association for the Batch
    association :course

    # Set a value for the end_date attribute
    end_date { Faker::Date.between(from: start_date, to: start_date + 3.months) }

    # Add other attributes for Batch as needed
  end

  factory :enrollment do
    status { 'pending' }

    # Create a valid association with the Student model
    association :student

    # Create a valid association with the Batch model
    association :batch
  end
end
