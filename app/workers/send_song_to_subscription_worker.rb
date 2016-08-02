class SendSongToSubscriptionWorker
  include Sidekiq::Worker

  # Exponential backoff: ten retries is about 7 hours
  sidekiq_options retry: 10

  def perform(song_id, date, subscription_id)
    song = Song.find(song_id)
    subscription = Subscription.find(subscription_id)

    return if song.sent_subscription_ids.include? subscription.id

    SubscriptionMailer.song(song, date, subscription).deliver
    song.append_sent_subscription_id subscription.id

  rescue ActiveRecord::RecordNotFound
    # Kill the job if song, subscription, curator, or user are not found
  end
end
