require 'test_helper'
require_relative '../support/integration_test_helpers'
require 'minitest/mock'

class RandomTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpers

  test 'copy from curator queue' do
    curator = users(:janet).curators.first

    song = curator.songs.create!(url: 'https://youtube.com/song',
                                 title: 'Queued Song',
                                 description: 'Music noises',
                                 image_url: 'https://i.ytimg.com/img.jpg',
                                 genre_ids: [ genres(:pop).id ])

    login_as users(:shannon)

    # Visit curator page
    get admin_curator_path(curator)
    assert_response :success

    # Should have a card for the song, which contains a "Random!" button
    assert_select '.card', 1 do
      assert_select "form[action='#{admin_random_copy_path(song)}']" do
        assert_select 'input.btn[value="Random!"]', 1
      end
    end

    # Click the "Random!" button
    assert_difference -> { Curator.random.songs.queued.count }, 1 do
      post admin_random_copy_path(song)
    end

    # Verify that the song was copied correctly
    new_song = Curator.random.songs.queued.order(created_at: :desc).first
    %i(url title image_url genre_ids).each do |attr|
      assert_equal song[attr], new_song[attr]
    end

    # Check that the description has attribution
    description = "#{song.description}\n\n(Originally curated by #{curator.user.name})"
    assert_equal description, new_song.description
  end
end
