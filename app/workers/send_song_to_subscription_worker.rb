class SendSongToSubscriptionWorker
  include Sidekiq::Worker

  # Exponential backoff: 11 retries is about 12 hours
  sidekiq_options retry: 11

  def perform(song_id, subscription_id, date, day, daily_message_id = nil)
    song = Song.find(song_id)
    subscription = Subscription.find(subscription_id)

    return if song.sent_subscription_ids.include? subscription.id

    SubscriptionMailer.song(song, subscription, date, day, daily_message_id).deliver
    song.append_sent_subscription_id subscription.id

  rescue ActiveRecord::RecordNotFound
    # Kill the job if song, subscription, curator, or user are not found
  end
end
