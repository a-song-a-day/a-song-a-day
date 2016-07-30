require 'test_helper'
require 'csv'

class UserTest < ActiveSupport::TestCase
  test 'requires name and email' do
    assert_no_difference -> { User.count } do
      user = User.create

      assert_includes user.errors, :name
      assert_includes user.errors, :email
    end
  end

  test 'prevents two users with same email address' do
    assert_difference -> { User.count }, 1 do
      first = User.create(name: 'Test', email: 'test@example.com')
    end

    assert_no_difference -> { User.count } do
      second = User.create(name: 'Example', email: 'test@example.com')
    end
  end

  test 'social links' do
    user = User.new

    assert_equal [], user.social_links

    user.twitter_url = "https://twitter.com/alisdair"

    assert_equal [["Twitter", "https://twitter.com/alisdair"]], user.social_links

    user.instagram_url = ""

    assert_equal [["Twitter", "https://twitter.com/alisdair"]], user.social_links

    user.soundcloud_url = "whatever"

    assert_equal [
      ["Twitter", "https://twitter.com/alisdair"],
      ["Soundcloud", "whatever"]
    ], user.social_links

    user.instagram_url = "photos"
    user.spotify_url = "spotify"

    assert_equal [
      ["Twitter", "https://twitter.com/alisdair"],
      ["Instagram", "photos"],
      ["Spotify", "spotify"],
      ["Soundcloud", "whatever"]
    ], user.social_links
  end

  test 'export to CSV' do
    users = User.where(id: [users(:alisdair).id, users(:shannon).id]).order(:name)
    csv = users.to_csv

    assert_equal String, csv.class, "creates a CSV string of users"

    parsed = CSV.parse(csv, headers: true)

    assert_equal User.attribute_names, parsed.headers, "exports all attributes"
    assert_equal 2, parsed.length, "exports all users"

    alisdair = parsed[0]

    assert_equal users(:alisdair).id.to_s, alisdair['id']
    assert_equal users(:alisdair).name, alisdair['name']
    assert_equal users(:alisdair).email, alisdair['email']

    shannon = parsed[1]

    assert_equal users(:shannon).id.to_s, shannon['id']
    assert_equal users(:shannon).name, shannon['name']
    assert_equal users(:shannon).email, shannon['email']
  end
end
