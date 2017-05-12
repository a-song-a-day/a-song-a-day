desc 'Schedule song sending jobs for active subscriptions'
task daily_song: :environment do
  date = Date.today.to_s(:long)
  day = Date::DAYNAMES[Date.today.wday]

  if Date.today.saturday? or Date.today.sunday?
    Rails.logger.info "Skipping daily song for #{date} (it's the weekend!)"
    next
  end

  Rails.logger.info "Daily song for #{date}: START"

  Curator.all.each do |curator|
    song = curator.next_song
    subscriptions = curator.subscriptions
    if subscriptions.empty?
      next
    end
    if song.nil?
      next
    end

    Rails.logger.info "#{date}: Sending '#{song.title}' " +
      "to #{subscriptions.count} subscribers of " +
      "'#{curator.title}' by #{curator.user.name}…"

    curator.subscriptions.includes(:user).order(:created_at).each do |subscription|
      if user.bounced
        next
      end
      SendSongToSubscriptionWorker.perform_async(song.id, subscription.id, date, day)
    end

    song.sent!
    Rails.logger.info "Song '#{song.title}' sent!"
  end

  Rails.logger.info "Daily song for #{date}: END"
end
