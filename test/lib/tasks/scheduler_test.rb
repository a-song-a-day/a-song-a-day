require 'test_helper'

class SchedulerTaskTest < ActiveSupport::TestCase
  setup do
    ASongADay::Application.load_tasks
  end
  test 'daily song' do
    # Friday the 12th
    Timecop.freeze(Time.new(2017, 5, 12, 10, 0, 0)) do
      song = songs(:two_moons)
      subscriptions(:thomas_electropop)
      assert_nil song.reload.sent_at
      Rake::Task['daily_song'].invoke
      assert_not_nil song.reload.sent_at
    end
  end

  test 'daily song on a Saturday' do
    # A saturday
    Timecop.freeze(Time.new(2017, 5, 13, 10, 0, 0)) do

      song = songs(:two_moons)
      subscriptions(:thomas_electropop)
      Rake::Task['daily_song'].invoke
      assert_nil song.reload.sent_at
    end
  end

  test 'skip bounced users' do
    song = songs(:two_moons)
    user = subscriptions(:thomas_electropop).user
    user.update_attributes(bounced: true)

    Rake::Task['daily_song'].invoke
    assert_nil song.reload.sent_at
  end
  test 'daily message' do
    Timecop.freeze(Time.new(2017, 5, 12, 10, 0, 0)) do
      songs(:two_moons)
      subscriptions(:thomas_electropop)
      daily_message = DailyMessage.create!(creator: users(:shannon), send_at: Date.today, message: 'Today is the best day!')

      Rake::Task['daily_song'].invoke
      assert_equal daily_message.reload.receivers, 1
    end
  end
end
