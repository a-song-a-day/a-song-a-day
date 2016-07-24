require 'test_helper'

class SubscriptionMailerTest < ActionMailer::TestCase
  test "created" do
    mail = SubscriptionMailer.created
    assert_equal "Created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "destroyed" do
    mail = SubscriptionMailer.destroyed
    assert_equal "Destroyed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "song" do
    mail = SubscriptionMailer.song
    assert_equal "Song", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
