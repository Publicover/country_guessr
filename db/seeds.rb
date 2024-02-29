# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts 'Starting seeds...'
if Rails.env.development?
  if User.count.zero?
    puts 'Creating user...'
    User.create(email: 'jim@jim.com', password: 'password')
  end
end

puts 'Creating surnames...'
50.times { Surname.create(name: Faker::Name.unique.last_name) }

puts 'Creating nationalities...'
10.times { Nationality.create(name: Faker::Nation.nationality) }

puts 'Creating surname_nationalities...'
Surname.all.each do |surname|
  nationality = Nationality.find(Nationality.pluck(:id).sample)
  SurnameNationality.create(
    surname_id: surname.id, 
    surname_name: surname.name, 
    nationality_id: nationality.id, 
    nationality_name: nationality.name
  )
end

puts 'Seeds complete.'