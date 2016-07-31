require 'test_helper'

class QueueCountClassHelperTest < ActionView::TestCase
  test 'success if more than two songs queued' do
    assert_equal 'text-success', queue_count_class(3)
    assert_equal 'text-success', queue_count_class(5)
    assert_equal 'text-success', queue_count_class(20)
  end

  test 'warning if one or two songs queued' do
    assert_equal 'text-warning', queue_count_class(1)
    assert_equal 'text-warning', queue_count_class(2)
  end

  test 'danger if zero songs queued' do
    assert_equal 'text-danger', queue_count_class(0)
  end

  test 'danger if called with nonsense arguments' do
    assert_equal 'text-danger', queue_count_class(-1)
  end
end
