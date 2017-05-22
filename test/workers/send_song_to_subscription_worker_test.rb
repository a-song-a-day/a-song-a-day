require 'test_helper'

class SendSongToSubscriptionWorkerTest < ActiveSupport::TestCase
  setup do
  end
  test "perform" do
    song = songs(:two_moons)
    subscription = subscriptions(:thomas_electropop)
    daily_message = DailyMessage.create!(message: "It is Tuesday!")

    SendSongToSubscriptionWorker.new.perform(song.id, subscription.id, '2017-05-22', daily_message.id)
    assert_includes song.reload.sent_subscription_ids, subscription.id
  end
end


