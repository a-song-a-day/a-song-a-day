require 'test_helper'

class SchedulerTaskTest < ActiveSupport::TestCase
  setup do
    ASongADay::Application.load_tasks
  end
  test 'daily song' do
    Timecop.travel(Time.new(2017, 5, 12, 10, 0, 0)) # Friday the 12th
    song = songs(:two_moons)
    subscriptions(:thomas_electropop)
    assert_nil song.reload.sent_at
    Rake::Task['daily_song'].invoke
    assert_not_nil song.reload.sent_at
    Timecop.return
  end

  test 'daily song on a Saturday' do
    Timecop.travel(Time.new(2017, 5, 13, 10, 0, 0)) # A saturday

    song = songs(:two_moons)
    subscriptions(:thomas_electropop)
    Rake::Task['daily_song'].invoke
    assert_nil song.reload.sent_at
    Timecop.return
  end

  test 'skip bounced users' do
    song = songs(:two_moons)
    user = subscriptions(:thomas_electropop).user
    user.update_attributes(bounced: true)

    Rake::Task['daily_song'].invoke
    assert_nil song.reload.sent_at
  end
end
