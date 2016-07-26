require 'test_helper'

class TransactionalMailerTest < ActionMailer::TestCase
  test 'login' do
    user = users(:alisdair)
    token = AccessToken.new(token: 'abc123')

    mail = TransactionalMailer.login(user, token)

    assert_equal 'Log in to A Song A Day', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['curators@asongaday.co'], mail.from
    assert_match token.token, mail.body.encoded
  end

  test 'welcome' do
    user = users(:alisdair)
    token = AccessToken.new(token: 'abc123')

    mail = TransactionalMailer.welcome(user, token)

    assert_equal 'Welcome to A Song A Day!', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['curators@asongaday.co'], mail.from
    assert_match token.token, mail.body.encoded
  end
end
