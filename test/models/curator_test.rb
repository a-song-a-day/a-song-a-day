require 'test_helper'

class CuratorTest < ActiveSupport::TestCase
  test 'can create' do
    assert_difference -> { Curator.count }, 1 do
      curator = Curator.create(user: users(:shannon),
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
      curator = Curator.create(user: users(:shannon),
                               title: 'First',
                               description: 'first',
                               genre: genres(:pop))
      curator = Curator.create(user: users(:shannon),
                               title: 'Second',
                               description: 'second',
                               genre: genres(:classical))
    end

    assert_equal 2, users(:shannon).curators.count
  end

  test 'random is false by default' do
    curator = Curator.create(user: users(:shannon),
                             title: 'Title here',
                             description: 'Description here',
                             genre: genres(:pop))

    assert_equal curator.random, false
  end

  test 'only one curator can be random' do
    assert_difference -> { Curator.count }, 1 do
      Curator.create(user: users(:shannon),
                     title: 'Random',
                     description: 'random',
                     random: true,
                     genre: genres(:pop))
    end

    assert_no_difference -> { Curator.count } do
      curator = Curator.create(user: users(:shannon),
                               title: 'Random',
                               description: 'random',
                               random: true,
                               genre: genres(:pop))
      assert_includes curator.errors, :random
    end
  end
end
