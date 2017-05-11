require 'test_helper'

class AccessTokenTest < ActiveSupport::TestCase
  test 'generates a token on create' do
    access_token = AccessToken.create(user: users(:admin))

    assert access_token.persisted?, 'saves access token'
    assert_match(/\A[0-9a-f]{32}\z/, access_token.token)
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
  test 'unexpired_for_two_weeks' do
    user = users(:thomas)
    # can't find 5 and 1 weeks
    user.access_tokens.create!(updated_at: Time.now - 5.weeks)
    assert_nil user.access_tokens.unexpired_for_two_weeks.first
    user.access_tokens.create!(updated_at: Time.now - 1.weeks)
    assert_nil user.access_tokens.unexpired_for_two_weeks.first
    # can find 15 days
    user.access_tokens.create!(updated_at: Time.now - 15.days)
    assert_not_nil user.access_tokens.unexpired_for_two_weeks.first
  end
  test 'find_or_create' do
    user = users(:thomas)
    assert_empty user.access_tokens
    assert_not_nil user.access_tokens.find_or_create
  end
end
