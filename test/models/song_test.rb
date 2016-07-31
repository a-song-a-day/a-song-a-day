require 'test_helper'

class SongTest < ActiveSupport::TestCase
  test 'requires url, title, description' do
    assert_no_difference -> { Song.count } do
      song = Song.create

      assert_includes song.errors, :url
      assert_includes song.errors, :title
      assert_includes song.errors, :description
    end
  end

  test 'appending sent subscription ids' do
    song = songs(:two_moons)

    assert_equal [], song.sent_subscription_ids

    song.append_sent_subscription_id 1
    song.reload

    assert_equal [1], song.sent_subscription_ids

    song.append_sent_subscription_id 5
    song.reload

    assert_equal [1, 5], song.sent_subscription_ids
  end
end
