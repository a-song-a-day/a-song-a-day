desc 'Schedule song sending jobs for active subscriptions'
task daily_song: :environment do
  date = Date.today.to_s(:long)
  day = Date::DAYNAMES[Date.today.wday]
  daily_message = DailyMessage.where(send_at: Date.today).first
  if daily_message
    daily_message_id = daily_message.id
  end
  receivers_count = 0

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
      unless subscription.user.receiving_mails?
        next
      end
      receivers_count += 1
      SendSongToSubscriptionWorker.perform_async(song.id, subscription.id, date, day, daily_message_id)
    end

    song.sent!
    Rails.logger.info "Song '#{song.title}' sent!"
    if daily_message
      daily_message.update_attribute(:receivers, receivers_count)
    end
  end

  Rails.logger.info "Daily song for #{date}: END"
end
