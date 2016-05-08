require 'test_helper'

class CuratorTest < ActiveSupport::TestCase
  test 'can create' do
    assert_difference -> { Curator.count }, 1 do
      curator = Curator.create(user: users(:shannon),
                               title: 'Title here',
                               description: 'Description blurb here')
    end
  end

  test 'requires user, title, and description' do
    assert_no_difference -> { Curator.count } do
      curator = Curator.create

      assert_includes curator.errors, :user
      assert_includes curator.errors, :title
      assert_includes curator.errors, :description
    end
  end

  test 'one user can be multiple curators' do
    assert_difference -> { Curator.count }, 2 do
      curator = Curator.create(user: users(:shannon),
                               title: 'First',
                               description: 'first')
      curator = Curator.create(user: users(:shannon),
                               title: 'Second',
                               description: 'second')
    end

    assert_equal 2, users(:shannon).curators.count
  end

  test 'random is false by default' do
    curator = Curator.create(user: users(:shannon),
                             title: 'Title here',
                             description: 'Description here')

    assert_equal curator.random, false
  end

  test 'only one curator can be random' do
    assert_difference -> { Curator.count }, 1 do
      Curator.create(user: users(:shannon),
                     title: 'Random',
                     description: 'random',
                     random: true)
    end

    assert_no_difference -> { Curator.count } do
      curator = Curator.create(user: users(:shannon),
                               title: 'Random',
                               description: 'random',
                               random: true)
      assert_includes curator.errors, :random
    end
  end
end
