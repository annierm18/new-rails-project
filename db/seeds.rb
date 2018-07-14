
require 'faker'



  5.times do
    User.create!(
      name: Faker::Name.unique.name,
      email: Faker::Internet.unique.email,
      password: Faker::Internet.unique.password
    )
  end
  users = User.all


 50.times do

   Wiki.create!(

    title: Faker::Title.unique.title,
    body:  Faker::Body.unique.body

   )
 end
 wikis = Wiki.all



 puts "Seed finished"
 puts "#{Wiki.count} wikis created"
 puts "#{User.count} user created"


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
