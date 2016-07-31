desc 'Schedule song sending jobs for active subscriptions'
task daily_song: :environment do
  date = Date.today.to_s(:long)

  Rails.logger.info "Daily song for #{date}: START"

  Curator.all.each do |curator|
    song = curator.next_song
    subscriptions = curator.subscriptions
    next if song.nil? or subscriptions.empty?

    Rails.logger.info "#{date}: Sending '#{song.title}' " +
      "to #{subscriptions.count} subscribers of " +
      "'#{curator.title}' by #{curator.user.name}…"

    curator.subscriptions.order(:created_at).each do |subscription|
      SendSongToSubscriptionWorker.perform_async(song.id, date, subscription.id)
    end

    song.sent!
    Rails.logger.info "Song '#{song.title}' sent!"
  end

  Rails.logger.info "Daily song for #{date}: END"
end
