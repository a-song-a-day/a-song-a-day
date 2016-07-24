require 'test_helper'

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
end
