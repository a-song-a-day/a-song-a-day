require 'test_helper'
require_relative '../support/integration_test_helpers'
require 'minitest/mock'

class CuratorsTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpers

  test 'show curator profile' do
    user = users(:janet)
    curator = user.curators.first

    login_as user

    # Login normally takes you to the profile page
    get admin_profile_path
    assert_response :success

    # Curators have a "Curate" nav link to the curators page
    assert_select ".nav-link[href='#{admin_curators_path}']", 'Curate'

    # If the curator has one profile, redirect to it
    get admin_curators_path
    assert_redirected_to admin_curator_path(curator)

    follow_redirect!
    assert_response :success
    assert_select 'h1', curator.title
  end

  test 'add song to queue' do
    user = users(:janet)
    curator = user.curators.first

    login_as user

    # Check for "Add song" link to the new song page
    get admin_curator_path(curator)
    assert_response :success
    assert_select "a[href='#{new_admin_curator_song_path(curator)}']", 'Add song'

    get new_admin_curator_song_path(curator)
    assert_response :success

    # Verify initial new song form
    assert_select "form[action='#{admin_curator_songs_path(curator)}']" do
      assert_select "input[type=hidden][name=fetch][value=true]", 1
      assert_select "input[name='song[url]']", 1
      assert_select "input[type=submit][value='Continue']"
    end

    # Stub out the OpenGraphService so that we don't hit the network
    perform = Proc.new do |song|
      song.attributes = {
        title: 'Rick Astley - Never Gonna Give You Up',
        image_url: 'https://i.ytimg.com/vi/dQw4w9WgXcQ/maxresdefault.jpg'
      }
    end

    # Submit the initial song URL
    OpenGraphService.stub :perform, perform do
      post admin_curator_songs_path(curator), params: {
        song: {
          url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
        },
        fetch: 'true'
      }
    end

    assert_response :success

    # Should show us a form with values pulled from OpenGraph
    assert_select "form[action='#{admin_curator_songs_path(curator)}']" do
      assert_select "input[name='song[title]'][value='Rick Astley - Never Gonna Give You Up']", 1
      assert_select "input[name='song[url]']", 1
      assert_select "input[name='song[image_url]'][value='https://i.ytimg.com/vi/dQw4w9WgXcQ/maxresdefault.jpg']", 1
      assert_select "input[type=submit][value=Preview][name=preview]"
      assert_select "input[type=submit][value='Queue song'][name=commit]"
    end

    # Create the song
    assert_difference -> { curator.songs.queued.count }, 1 do
      post admin_curator_songs_path(curator), params: {
        song: {
          title: 'Rick Astley - Never Gonna Give You Up',
          description: 'Blue-eyed soul classic',
          url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
          image_url: 'https://i.ytimg.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
          genre_ids: [ '', genres(:pop).id ]
        },
        commit: 'Queue song'
      }
    end

    # Check the song was created correctly
    song = curator.songs.queued.first
    assert_equal song.title, 'Rick Astley - Never Gonna Give You Up'
    assert_equal song.description, 'Blue-eyed soul classic'
    assert_equal song.url, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
    assert_equal song.image_url, 'https://i.ytimg.com/vi/dQw4w9WgXcQ/maxresdefault.jpg'
    assert_equal song.genres, [ genres(:pop) ]

    assert_redirected_to admin_curator_songs_path(curator)

    follow_redirect!
    assert_response :success

    # Song queue displays the song
    assert_select 'h1', 'Song Queue'
    assert_select '.text-muted', 'Displaying 1 song'
    assert_select '.card', 1 do
      assert_select 'h5', song.title
      assert_select 'p', song.description
    end
  end

  test 'shows dates for queued songs' do
    user = users(:janet)
    curator = user.curators.first

    7.times do |i|
      curator.songs.create!(url: "https://youtube.com/#{i}",
                            title: "Queued Song #{i}",
                            description: 'Music noises')
    end

    login_as user

    travel_to DateTime.parse('Wednesday 17th August 2016 17:00 +0100') do
      get admin_curator_path(curator)
      assert_response :success

      assert_select '.card', 5 do |cards|
        cards.each_with_index do |card, i|
          assert_select card, 'a', "Queued Song #{i}"
        end

        assert_select cards[0], '.text-warning', 'Queued for August 18, 2016'
        assert_select cards[1], '.text-warning', 'Queued for August 19, 2016'
        assert_select cards[2], '.text-warning', 'Queued for August 22, 2016'
        assert_select cards[3], '.text-warning', 'Queued for August 23, 2016'
        assert_select cards[4], '.text-warning', 'Queued for August 24, 2016'
      end
    end
  end

  test 'edit curator profile' do
    user = users(:janet)
    curator = user.curators.first
    login_as user

    get edit_admin_curator_path(curator)
    assert_response :success

    # Verify curator profile form
    assert_select "form[action='#{admin_curator_path(curator)}']" do
      assert_select "input[name='curator[title]']", 1
      assert_select "textarea[name='curator[description]']", 1
      assert_select "select[name='curator[genre_id]']", 1
      assert_select '.option input[type=checkbox]', Genre.count
      assert_select "input[type=submit][value=Preview][name=preview]"
      assert_select "input[type=submit][value='Save curator profile'][name=commit]"
    end

    patch admin_curator_path(curator), params: {
      curator: {
        title: 'Neo Classical',
        description: 'Old but new?',
        genre_id: genres(:pop).id,
        genre_ids: [ '', genres(:classical).id ]
      },
      commit: 'Save curator profile'
    }
    assert_redirected_to admin_curator_path(curator)

    curator.reload
    assert_equal curator.title, 'Neo Classical'
    assert_equal curator.description, 'Old but new?'
    assert_equal curator.genre, genres(:pop)
    assert_equal curator.genres.sort, [ genres(:pop), genres(:classical) ].sort

    follow_redirect!
    assert_response :success

    assert_select 'h1', curator.title
  end

  test 'edit user profile: validation error' do
    user = users(:janet)
    curator = user.curators.first
    login_as user

    get edit_admin_curator_path(curator)
    assert_response :success

    # Verify curator profile form
    assert_select "form[action='#{admin_curator_path(curator)}']" do
      assert_select "input[name='curator[title]']", 1
      assert_select "textarea[name='curator[description]']", 1
      assert_select "select[name='curator[genre_id]']", 1
      assert_select '.option input[type=checkbox]', Genre.count
      assert_select "input[type=submit][value=Preview][name=preview]"
      assert_select "input[type=submit][value='Save curator profile'][name=commit]"
    end

    patch admin_curator_path(curator), params: {
      curator: {
        title: '',
        description: '',
        genre_id: '',
        genre_ids: [ '', genres(:classical).id ]
      },
      commit: 'Save curator profile'
    }

    assert_response :success
    assert_select 'h1', 'Edit Curator Profile'
    assert_select "form[action='#{admin_curator_path(curator)}']" do
      assert_select ".has-danger input[name='curator[title]']", 1
      assert_select ".has-danger textarea[name='curator[description]']", 1
      assert_select ".has-danger select[name='curator[genre_id]']", 1
    end

    curator.reload
    assert_equal curator.title, 'Classical and Indie Smash'
    assert_equal curator.description, 'Modern classical plus chamber pop, art rock, and genre-benders.'
    assert_equal curator.genre, genres(:classical)
  end
end
