# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

shannon = User.create!(name: 'Shannon Byrne',
                       email: 'shannon@asongaday.co',
                       curator: true,
                       admin: true)
random = Curator.create!(title: 'Random',
                         description: 'Just great music',
                         user: shannon,
                         random: true)

genres = <<EOF.split("\n")
Classical
Country/Blues
EDM/Trance
Electronic Pop
Folk/Americana
Funk/Soul
HipHop/Rap
House/Techno
Indie Rock
Jazz
Metal
Pop
Punk
R&B
Rock
Shoegaze
Trap/Future Bass
World
EOF
genres.each {|name| Genre.create!(name: name, primary: true) }

secondary_genres = <<EOF.split("\n")
Acoustic
Alternative Rock
Ambient
Bluegrass
Classic Rock
Dance Pop
Electronic
Emo Rock
Garage Rock
Indie Pop
Lo-Fi Rock
Motown
New Wave
Prog Rock
Singer-Songwriter
EOF
secondary_genres.each {|name| Genre.create!(name: name) }
