# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create([{
    first_name: 'Jon',
    last_name: 'Knot',
    email: 'jon@gmail.com',
    password: 'whattheheck?' }]
               )
Lifehack.create([{
    title: 'How to tie a tie',
    description: 'tie a knot',
    creator_id: "#{User.first.id}"  }, {
    title: 'How to tie a tie1',
    creator_id: "#{User.first.id}" }])
