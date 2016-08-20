shannon = User.create!(name: 'Shannon Byrne',
                       email: 'shannon@asongaday.co',
                       curator: true,
                       admin: true)


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

random = Curator.create!(title: 'Random',
                         description: 'Just great music',
                         user: shannon,
                         random: true,
                         genre: Genre.find_by_name('Pop'))

# Make sure the database isn't completely empty
user = User.create!(name: 'Name', email: 'test12345@example.com')
random.subscriptions.create!(user: user)
random.songs.create!(url: 'https://www.youtube.com/watch?v=kk0WRHV_vt8',
                     image_url: 'https://i.ytimg.com/vi/kk0WRHV_vt8/maxresdefault.jpg',
                     title: 'Snarky Puppy - Shofukan (We Like It Here)',
                     description: 'Description goes here',
                     sent_at: Time.now)
