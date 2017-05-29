require 'test_helper'

class CuratorTest < ActiveSupport::TestCase
  test 'can create' do
    assert_difference -> { Curator.count }, 1 do
      Curator.create(user: users(:shannon),
                               title: 'Title here',
                               description: 'Description blurb here',
                               genre: genres(:pop))
    end
  end

  test 'requires user, title, and description' do
    assert_no_difference -> { Curator.count } do
      curator = Curator.create

      assert_includes curator.errors, :user
      assert_includes curator.errors, :title
      assert_includes curator.errors, :description
      assert_includes curator.errors, :genre
    end
  end

  test 'one user can be multiple curators' do
    assert_difference -> { Curator.count }, 2 do
      curator = Curator.create(user: users(:alisdair),
                               title: 'First',
                               description: 'first',
                               genre: genres(:pop))
      curator = Curator.create(user: users(:alisdair),
                               title: 'Second',
                               description: 'second',
                               genre: genres(:classical))
    end

    assert_equal 2, users(:alisdair).curators.count
  end

  test 'random is false by default' do
    curator = Curator.create(user: users(:shannon),
                             title: 'Title here',
                             description: 'Description here',
                             genre: genres(:pop))

    assert_equal curator.random, false
  end

  test 'only one curator can be random' do
    assert_equal curators(:random), Curator.random

    assert_no_difference -> { Curator.count } do
      curator = Curator.create(user: users(:shannon),
                               title: 'Random',
                               description: 'random',
                               random: true,
                               genre: genres(:pop))
      assert_includes curator.errors, :random
    end
  end

  def song_params(name, age, sent_ago=nil)
    {
      url: name,
      title: name,
      description: name,
      created_at: Time.now - age,
      sent_at: sent_ago ? Time.now - sent_ago : nil
    }
  end

  test 'next song' do
    curator = curators(:random)

    assert_equal 0, curator.songs.count

    genres(:pop)
    songs = [
      ['0', 5.days, 4.days],
      ['1', 5.days, 3.days],
      ['2', 5.days],
      ['3', 2.days],
      ['4', 3.days],
    ].map {|args| curator.songs.create(song_params(*args)) }

    assert_equal songs[2], curator.next_song

    songs[2].sent!

    assert_equal songs[3], curator.next_song

    songs[3].sent!

    assert_equal songs[4], curator.next_song

    songs[4].sent!

    assert_equal nil, curator.next_song
  end
  test "merge_and_delete!" do
    curator = curators(:electropop)
    subscription = curator.subscriptions.create(user: users(:shannon))
    subscriptions(:thomas_electropop)
    song = songs(:two_moons)
    other_curator = curators(:random)
    other_curator.subscriptions.create(user: users(:thomas))
    curator.merge_and_delete!(other_curator)
    assert_equal subscription.reload.curator, other_curator
    assert_equal curator.subscriptions.size, 2
    assert_equal song.reload.curator, other_curator
    assert_nil Curator.where(id: curator.id).first
  end
end
