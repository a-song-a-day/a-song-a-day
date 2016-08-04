class SubscriptionMailer < ApplicationMailer
  add_template_helper GravatarUrlHelper

  def created(subscription)
    @subscription = subscription
    @curator = subscription.curator

    title = @curator.random? ? "great music" : @curator.title
    @preheader = "Yay! You're now subscribed to #{title} on A Song A Day"

    mail to: subscription.user.email, subject: 'Subscribed to A Song A Day'
  end

  def destroyed(subscription)
    @subscription = subscription
    @curator = subscription.curator

    title = @curator.random? ? "great music" : @curator.title
    @preheader = "Aww! You've unsubscribed from #{title} on A Song A Day"

    mail to: subscription.user.email, subject: 'Unsubscribed from A Song A Day'
  end

  def song(song, date, subscription)
    @song = song
    @curator = subscription.curator
    @date = date
    @subscription = subscription

    @preheader = "Today's song: #{@song.title}"

    mail to: subscription.user.email,
      subject: "Today's #{@curator.title} song is..."
  end
end
