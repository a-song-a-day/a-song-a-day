[![Build Status](https://travis-ci.org/a-song-a-day/a-song-a-day.svg?branch=master)](https://travis-ci.org/a-song-a-day/a-song-a-day)
[![Coverage Status](https://coveralls.io/repos/github/a-song-a-day/a-song-a-day/badge.svg?branch=master)](https://coveralls.io/github/a-song-a-day/a-song-a-day?branch=master)

# A Song A Day

For those "too busy" to discover new music.

## Development

Requires Ruby 2.3.1. Some basics:

    bundle install
    bin/rails db:setup
    bin/rails test
    bin/rails server

Visit http://localhost:3000/ to see the app.

## Getting started

- Sign up for a new account locally using the normal sign-up flow
- At the end, you should get a fake email opening in your browser (via the letter_opener gem)
- Log out, then sign in as shannon@asongaday.co (default admin), again by the fake email
- Browse around the admin dashboard and enjoy

## Maintenance notes

- You can check out sample email templates at [http://localhost:3000/rails/mailers/](http://localhost:3000/rails/mailers/)
- There are no user passwords; login is via "magic links" sent by email
- Test coverage isn't too bad, except for the genre-based setup flow
- The app uses a pre-release of Bootstrap v4, which still has a fairly unstable API; upgrading is risky, so be careful
- This repository has Heroku auto deployments on PRs, which is handy
- If a Travis build on master succeeds, it goes to production

This was originally built by [@alisdair](https://github.com/alisdair). If you have problems, he might be able to help.
