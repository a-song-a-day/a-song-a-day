require 'test_helper'

class AlertHelperTest < ActionView::TestCase
  test 'alert is alert-danger' do
    assert_equal 'alert-danger', alert_class('alert')
  end

  test 'notice is alert-info' do
    assert_equal 'alert-info', alert_class('notice')
  end

  test 'success is alert-success' do
    assert_equal 'alert-success', alert_class('success')
  end

  test 'anything else is alert-warning' do
    assert_equal 'alert-warning', alert_class('warning')
    assert_equal 'alert-warning', alert_class('potato')
    assert_equal 'alert-warning', alert_class('horse')
  end
end
