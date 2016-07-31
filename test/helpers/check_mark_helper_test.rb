require 'test_helper'

class CheckMarkHelperTest < ActionView::TestCase
  test 'success if true' do
    assert_dom_equal %{<span class="text-success">&#x2714;</span>},
      check_mark(true)
  end

  test 'success if truthy' do
    assert_dom_equal %{<span class="text-success">&#x2714;</span>},
      check_mark(1)
  end

  test 'danger if false' do
    assert_dom_equal %{<span class="text-danger">&#x2718;</span>},
      check_mark(false)
  end

  test 'danger if falsy' do
    assert_dom_equal %{<span class="text-danger">&#x2718;</span>},
      check_mark(nil)
  end
end
