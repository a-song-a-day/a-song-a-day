class SubscriptionMailer < ApplicationMailer
  add_template_helper GravatarUrlHelper
  add_template_helper MarkdownHelper

  def created(subscription)
    @subscription = subscription
    @curator = subscription.curator

    title = @curator.random? ? "great music" : @curator.title
    @preheader = "Yay! You're now subscribed to #{title} on A Song A Day"

    headers['X-Mailgun-Campaign-Id'] = 'subscribe'

    mail to: subscription.user.email, subject: 'Subscribed to A Song A Day'
  end

  def destroyed(subscription)
    @subscription = subscription
    @curator = subscription.curator

    title = @curator.random? ? "great music" : @curator.title
    @preheader = "Aww! You've unsubscribed from #{title} on A Song A Day"

    headers['X-Mailgun-Campaign-Id'] = 'unsubscribe'

    mail to: subscription.user.email, subject: 'Unsubscribed from A Song A Day'
  end

  def song(song, subscription, date, day, daily_message_id = nil)
    @song = song
    @curator = subscription.curator
    @subscription = subscription
    @date = date
    @day = day
    @daily_message = nil
    if daily_message_id
      @daily_message = DailyMessage.find(daily_message_id)
    end

    @preheader = "#{day}'s song: #{@song.title}"

    headers['X-Mailgun-Tag'] = "curator-#{subscription.curator.id}"
    headers['X-Mailgun-Campaign-Id'] = 'daily-song'

    mail to: subscription.user.email,
      subject: "#{day}'s song is..."
  end
end
