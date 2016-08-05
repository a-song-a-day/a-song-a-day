require 'test_helper'
require_relative '../support/integration_test_helpers'

class SubscriptionsTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpers

  test 'receive song, unsubscribe' do
    user = users(:alisdair)
    login_as user

    # Send a song email to the user
    subscription = user.subscriptions.create(curator: curators(:electropop))
    song = songs(:two_moons)

    SubscriptionMailer.song(song, subscription, Date.today.to_s, 'Tuesday').deliver

    # Verify the song email content and links
    assert_select_email do
      assert_select 'p', /#{curators(:electropop).title}/
      assert_select 'p', /#{curators(:electropop).user.name}/
      assert_select "a[href='#{admin_subscriptions_url}']", 'unsubscribe from this list'
    end
    ActionMailer::Base.deliveries.clear

    get admin_subscriptions_path
    assert_response :success

    # Shows subscriptions page with unsubscribe button
    assert_select 'h1', 'Subscriptions'
    assert_select "form[action='#{admin_subscription_path(subscription)}']" do
      assert_select "input[type=hidden][name=_method][value=delete]"
      assert_select 'input[type=submit][value=Unsubscribe]'
    end

    assert_difference -> { user.subscriptions.count }, -1 do
      delete admin_subscription_url(subscription)
    end
    assert_redirected_to admin_subscriptions_path

    # Should receive email notification of unsubscribing
    assert_select_email do
      assert_select 'p', "You're now unsubscribed, and you won't receive any more songs."
    end

    follow_redirect!
    assert_response :success

    # Now unsubscribed, option to resubscribe is there
    assert_select 'h1', 'Subscriptions'
    assert_select "form[action='#{admin_subscriptions_path}']" do
      assert_select 'button', 'Resubscribe?'
    end
  end

  test 'resubscribe to random' do
    user = users(:alisdair)
    login_as user

    assert user.subscriptions.empty?

    # Visit subscriptions page
    get admin_subscriptions_path
    assert_response :success

    assert_select 'h1', 'Subscriptions'
    assert_select "form[action='#{admin_subscriptions_path}']" do
      assert_select "input[type=hidden]" +
        "[name='subscription[curator_id]']" +
        "[value='#{curators(:random).id}']"
      assert_select 'button', 'Resubscribe?'
    end

    assert_difference -> { user.subscriptions.count }, 1 do
      post admin_subscriptions_url, params: {
        subscription: {
          curator_id: curators(:random).id
        }
      }
    end
    assert_redirected_to admin_subscriptions_path

    subscription = user.subscriptions.first
    assert_equal curators(:random), subscription.curator

    # Subscribing confirms by email
    assert_select_email do
      assert_select 'p', "It's music time! Here's what you've got to look forward to:"
      assert_select 'h2', subscription.curator.title
      assert_select 'h3', subscription.curator.user.name
    end

    follow_redirect!
    assert_response :success

    # Shows subscriptions page with unsubscribe button
    assert_select 'h1', 'Subscriptions'
    assert_select "form[action='#{admin_subscription_path(subscription)}']" do
      assert_select "input[type=hidden][name=_method][value=delete]"
      assert_select 'input[type=submit][value=Unsubscribe]'
    end
  end
end
