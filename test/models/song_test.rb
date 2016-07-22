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
end
