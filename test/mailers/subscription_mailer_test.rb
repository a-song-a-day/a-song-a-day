require 'test_helper'

class SubscriptionMailerTest < ActionMailer::TestCase
  test "created" do
    curator = curators(:electropop)
    assert_equal users(:shannon), curator.user

    user = users(:alisdair)
    subscription = Subscription.create(curator: curator, user: user)

    mail = SubscriptionMailer.created(subscription)
    assert_equal 'Subscribed to A Song A Day', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['curators@asongaday.co'], mail.from
    assert_match curator.title, mail.body.encoded
  end

  test "destroyed" do
    curator = curators(:electropop)
    user = users(:alisdair)
    subscription = Subscription.create(curator: curator, user: user)

    mail = SubscriptionMailer.destroyed(subscription)
    assert_equal 'Unsubscribed from A Song A Day', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['curators@asongaday.co'], mail.from
  end

  test "song" do
    curator = curators(:electropop)
    user = users(:alisdair)
    subscription = Subscription.create!(curator: curator, user: user)
    song = songs(:two_moons)
    date = 'July 24, 2016'
    day = 'Tuesday'

    curator.songs.push song

    mail = SubscriptionMailer.song(song, subscription, date, day)
    assert_match(/#{day}/, mail.subject)
    assert_equal [user.email], mail.to
    assert_equal ['curators@asongaday.co'], mail.from
    assert_match song.title, mail.body.encoded
    assert_match date, mail.body.encoded
  end
  test "song with daily message" do
    subscription = subscriptions(:thomas_electropop)
    daily_message = DailyMessage.create!(creator: users(:shannon), send_at: Date.today, message: 'Today is the best day!')
    song = songs(:two_moons)

    mail = SubscriptionMailer.song(song, subscription, Date.today.to_s, 'Monday', daily_message)
    assert_match(/Today is the best day!/, mail.body.encoded)
  end
end
