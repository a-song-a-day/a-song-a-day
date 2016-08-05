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

  def song(song, subscription, date, day)
    @song = song
    @curator = subscription.curator
    @subscription = subscription
    @date = date
    @day = day

    @preheader = "#{day}'s song: #{@song.title}"

    mail to: subscription.user.email,
      subject: "#{day}'s #{@curator.title} song is..."
  end
end
