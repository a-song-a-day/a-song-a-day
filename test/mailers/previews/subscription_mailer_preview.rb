# http://a-song-a-day.dev/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview

  # http://a-song-a-day.dev/rails/mailers/subscription_mailer/created
  def created
    subscription = Subscription.first!
    SubscriptionMailer.created(subscription)
  end

  # http://a-song-a-day.dev/rails/mailers/subscription_mailer/destroyed
  def destroyed
    subscription = Subscription.first!
    SubscriptionMailer.destroyed(subscription)
  end

  # http://a-song-a-day.dev/rails/mailers/subscription_mailer/song
  def song
    song = Song.first!
    date = Date.today.to_s(:long)
    subscription = song.curator.subscriptions.first!
    SubscriptionMailer.song(song, date, subscription)
  end

end
