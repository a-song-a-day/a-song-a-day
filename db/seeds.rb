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
Acoustic
Alternative Rock
Americana
Avant Garde
Blues
Bluegrass
Chill (electronic)
Classic Rock
Classical
Country
Dance Pop
Electronic Pop
Emo Rock
Folk
Funk
Garage Rock
Hip Hop & Rap
House Music
Indie Pop
Indie Rock
Jam Bands
Jazz
Lo-Fi Rock
Metal
Motown
New Wave
Pop
Prog Rock
Punk
R&B
Rock
Singer-Songwriter
Shoegaze
Soul
Techno
Trap
Trance
World
EOF
genres.each {|name| Genre.create!(name: name) }
