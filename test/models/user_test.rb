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
end
