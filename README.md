# README

# School Management System

This is a School Management System application built with Ruby on Rails. It allows schools to manage their courses, batches, students, and enrollments.

## Getting Started

### Prerequisites

Before running the application, make sure you have the following installed on your system:

- Ruby (version 3.0.2)
- Ruby on Rails (version 6.1.4)
- sqlLite

### Installing

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/your-username/school_management_app.git

2. Change into the application directory:

   ```bash
   cd school_management_app

3. Install the required gems:

   ```ruby
   bundle install

4. Create the database and run the migrations:

    ```ruby
    rails db:drop (optional: if rails db:create throws error run this first)
    rails db:create
    rails db:migrate

5. you can seed the database with data:

    ```ruby
    rails db:seed

### Running the application

1. Start the Rails server:

    ```ruby
    rails server

- The application will be accessible at http://localhost:3000.

### Running Tests

1. To run the RSpec tests, use the following command:

    ```ruby
    bundle exec rspec

### How to use the Appliaction

1. When you seed the application with `rails db:seed`, apart from other data 7 users will be created.

2. Out of the seven users: Admin - 1 (No. of users) , School_admin - 2 (No. of users), Students - 4 (No. of users) 

3. ### The credentials for all 7 users are given below:-

A. Admin:
   Email - admin@example.com
   Password - password

B. School Admin:
  1. Email - school_admin1@example.com
     Password - password

  2. Email - school_admin2@example.com
     Password - password

C. Students:
  1. Email - student1@example.com
     Password - password

  2. Email - student2@example.com
     Password - password

  3. Email - michael@example.com
     Password - password

  4. Email - emma@example.com
     Password - password

### Login with any user and play with the app. Every user has their own privileges and features as described in the assignment.

## Thank You





    

   