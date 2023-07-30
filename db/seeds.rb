# db/seeds.rb

# Seed data for Admin user
admin_user = User.create!(
  user_type: 'admin',
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password'
)

# Seed data for School Admin users
school_admin_user1 = User.create!(
  user_type: 'school_admin',
  email: 'school_admin1@example.com',
  password: 'password',
  password_confirmation: 'password'
)

school_admin_user2 = User.create!(
  user_type: 'school_admin',
  email: 'school_admin2@example.com',
  password: 'password',
  password_confirmation: 'password'
)

# Seed data for Student users
student_user1 = User.create!(
  user_type: 'student',
  email: 'student1@example.com',
  password: 'password',
  password_confirmation: 'password'
)

student_user2 = User.create!(
  user_type: 'student',
  email: 'student2@example.com',
  password: 'password',
  password_confirmation: 'password'
)

student_user3 = User.create!(
  user_type: 'student',
  email: 'michael@example.com',
  password: 'password',
  password_confirmation: 'password'
)

student_user4 = User.create!(
  user_type: 'student',
  email: 'emma@example.com',
  password: 'password',
  password_confirmation: 'password'
)

# Seed data for Schools
school1 = School.create!(
  name: 'School A',
  address: '123 Main Street',
  phone: '1234567890',
  user_id: school_admin_user1.id
)

school2 = School.create!(
  name: 'School B',
  address: '456 Oak Avenue',
  phone: '9876543210',
  user_id: school_admin_user2.id
)

# Seed data for Courses (associated with Schools)
course1 = school1.courses.create!(
  name: 'Mathematics',
  description: 'Fundamentals of Mathematics'
)

course2 = school2.courses.create!(
  name: 'Science',
  description: 'Introduction to Science'
)

# Seed data for Batches (associated with Courses)
batch1 = course1.batches.create!(
  name: 'Batch 2023',
  start_date: Date.new(2023, 9, 1),
  end_date: Date.new(2024, 5, 31)
)

batch2 = course2.batches.create!(
  name: 'Batch 2024',
  start_date: Date.new(2024, 9, 1),
  end_date: Date.new(2025, 5, 31)
)

# Seed data for Students (associated with Schools and Batches through Enrollments)
student1 = Student.create!(
  name: 'John Doe',
  roll_number: '001',
  school: school1,
  email: student_user1.email,
  user_id: student_user1.id
)

student2 = Student.create!(
  name: 'Jane Smith',
  roll_number: '002',
  school: school1,
  email: student_user2.email,
  user_id: student_user2.id
)

# Some students enrolled in Batch 2
student3 = Student.create!(
  name: 'Michael Johnson',
  roll_number: '003',
  school: school2,
  email: 'michael@example.com',
  user_id: student_user3.id
)

student4 = Student.create!(
  name: 'Emma Watson',
  roll_number: '004',
  school: school2,
  email: 'emma@example.com',
  user_id: student_user4.id
)

# Now, let's create enrollments to associate students with batches
enrollment1 = Enrollment.create!(
  student: student1,
  batch: batch1,
  status: 'approved' # Set the appropriate status for enrollment
)

enrollment2 = Enrollment.create!(
  student: student2,
  batch: batch1,
  status: 'approved' # Set the appropriate status for enrollment
)

# Enrolling students in Batch 2
enrollment3 = Enrollment.create!(
  student: student3,
  batch: batch2,
  status: 'approved' # Set the appropriate status for enrollment
)

enrollment4 = Enrollment.create!(
  student: student4,
  batch: batch2,
  status: 'approved' # Set the appropriate status for enrollment
)

# Add more students and enrollments as needed...
