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
end
