require 'test_helper'

class AccessTokenTest < ActiveSupport::TestCase
  test 'generates a token on create' do
    access_token = AccessToken.create(user: users(:admin))

    assert access_token.persisted?, 'saves access token'
    assert_match /\A[0-9a-f]{32}\z/, access_token.token
  end

  test 'requires a user' do
    access_token = AccessToken.create

    assert access_token.invalid?, 'access token is invalid'
    assert_includes access_token.errors, :user, 'has error on the user'
  end

  test 'expires' do
    access_token = AccessToken.create(user: users(:admin))

    assert_includes AccessToken.unexpired, access_token

    access_token.update updated_at: 29.days.ago
    
    assert_not_includes AccessToken.unexpired, access_token
  end
end
