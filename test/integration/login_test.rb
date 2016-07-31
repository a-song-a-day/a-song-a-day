require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  test 'can log in through the home page' do
    # Visit homepage
    get '/'
    assert_response :success

    # Look for log in link
    assert_select "a[href='#{new_session_path}']", 'Log In'

    # Click "Log In"
    get new_session_path
    assert_response :success

    # Verify login form
    assert_select "form[action='#{session_path}'][method=post]" do
      assert_select 'input[type=email]', 1
      assert_select 'button', 'Send log-in email'
    end

    # Set up a normal user with some existing access tokens
    user = users(:alisdair)
    user.access_tokens.destroy_all

    user.access_tokens.create(updated_at: 5.weeks.ago)
    user.access_tokens.create(updated_at: 10.weeks.ago)
    user.access_tokens.create(updated_at: 3.weeks.ago)

    assert_equal 1, user.access_tokens.unexpired.count
    assert_equal 2, user.access_tokens.expired.count

    # Logging in creates a new access token
    assert_difference -> { user.access_tokens.unexpired.count }, 1 do
      post session_path, params: { email: user.email }
    end

    # Sending a new token clears out all expired tokens
    assert_equal 0, user.access_tokens.expired.count

    token = user.access_tokens.order(updated_at: :desc).first!

    # Login email sent
    assert_select_email do
      assert_select 'h1', 'Welcome back, Alisdair McDiarmid'
      assert_select "a[href='#{token_url(token)}']", 'Log in to your account'
    end

    # Shows welcome back page
    assert_response :success
    assert_select 'h1', 'Welcome back!'

    # Simulate clicking on the token link from welcome email
    get token_url(token)
    assert_redirected_to admin_profile_path

    follow_redirect!
    assert_response :success

    # Showing my profile
    assert_select 'h1', 'Profile'
    assert_select 'h3', 'Alisdair McDiarmid'
  end

  test 'redirect back to login-protected page' do
    user = users(:alisdair)

    # Visit subscriptions page while logged out
    get admin_subscriptions_path

    # Redirects to login path
    assert_response :redirect
    assert_redirected_to new_session_path

    # Log in, click on link in email
    post session_path, params: { email: user.email }

    token = user.access_tokens.order(updated_at: :desc).first!

    get token_url(token)

    # Redirected back to the page we tried to get to
    assert_redirected_to admin_subscriptions_path
  end
end
