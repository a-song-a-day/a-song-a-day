require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  test 'can create' do
    assert_difference -> { Subscription.count }, 1 do
      subscription = Subscription.create(user: users(:alisdair),
                                         curator: curators(:shannon))
    end
  end

  test 'requires user and curator' do
    assert_no_difference -> { Subscription.count } do
      subscription = Subscription.create

      assert_includes subscription.errors, :user
      assert_includes subscription.errors, :curator
    end
  end

  test 'user and curator are unque' do
    subscription = Subscription.create(user: users(:alisdair),
                                       curator: curators(:shannon))
    assert_no_difference -> { Subscription.count } do
      subscription = Subscription.create(user: users(:alisdair),
                                         curator: curators(:shannon))
    end
  end
end
