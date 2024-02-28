# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts 'Starting seeds...'
if Rails.env.development?
  puts 'Creating user...'
  User.create(email: 'jim@jim.com', password: 'password')
end

puts 'Seeds complete.'