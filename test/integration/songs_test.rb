require 'test_helper'
require_relative '../support/integration_test_helpers'
require 'minitest/mock'

class SongsTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpers

  test 'list curator songs' do
    user = users(:janet)
    curator = user.curators.first
    queued = curator.songs.create!(url: 'https://youtube.com',
                                   title: 'Queued Song',
                                   description: 'Music noises')
    sent = curator.songs.create!(url: 'https://bandcamp.com',
                                 title: 'Sent Song',
                                 description: 'Music sounds',
                                 sent_at: Time.now - 1.day)

    login_as user

    # Login normally takes you to the profile page
    get admin_curator_songs_path(curator)
    assert_response :success

    assert_select 'h1', 'Song Queue'

    assert_select '.card', 2, 'shows all songs by default'
    assert_select '.card a', queued.title, 'shows queued song'
    assert_select '.card a', sent.title, 'shows sent song'

    assert_select '.btn-group' do |group|
      assert_select group, '.btn.active:contains("All")'
      assert_select group, '.btn:contains("Queued")'
      assert_select group, '.btn:contains("Sent")'
    end

    # Show queued songs
    get admin_curator_songs_path(curator, type: 'queued') 
    assert_response :success

    assert_select '.card', 1, 'shows one song'
    assert_select '.card a', queued.title, 'shows queued song'

    assert_select '.btn-group' do |group|
      assert_select group, '.btn:contains("All")'
      assert_select group, '.btn.active:contains("Queued")'
      assert_select group, '.btn:contains("Sent")'
    end

    # Show sent songs
    get admin_curator_songs_path(curator, type: 'sent') 
    assert_response :success

    assert_select '.card', 1, 'shows one song'
    assert_select '.card a', sent.title, 'shows sent song'

    assert_select '.btn-group' do |group|
      assert_select group, '.btn:contains("All")'
      assert_select group, '.btn:contains("Queued")'
      assert_select group, '.btn.active:contains("Sent")'
    end
  end
  test "move position to next" do
    user = users(:janet)
    login_as user
    curator = user.curators.first
    curator.songs.create!(url: 'https://bandcamp.com',
                                 title: 'Sent Song',
                                 description: 'Music sounds',
                                 sent_at: Time.now - 1.day)
    queued1 = curator.songs.create!(url: 'https://youtube.com',
                                   title: 'Queued Song 1',
                                   description: 'Music noises')
    queued2 = curator.songs.create!(url: 'https://youtube.com',
                                   title: 'Queued Song 2',
                                   description: 'Music noises')
    assert_equal 2, queued1.position
    assert_equal 3, queued2.position
    post reposition_admin_curator_song_path(curator_id: curator.id, id: queued2.id, position: 'next')
    assert_equal 3, queued1.reload.position
    assert_equal 2, queued2.reload.position
  end
end
