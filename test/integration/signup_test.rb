require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest
  test 'can sign up through home page' do
    # Visit homepage
    get '/'
    assert_response :success

    # Verify initial signup form exists
    assert_select "form[action='#{signup_start_url}'][method=get]", 2 do |forms|
      forms.each do |form|
        assert_select form, 'input[type=email]'
        assert_select form, 'button', 'Sign Up'
      end
    end

    # Simulate filling in email and clicking "Sign Up"
    get signup_start_url(email: 'test@example.com')
    assert_response :success

    # Verify full signup form exists
    assert_select "form[action='#{signup_start_url}'][method=post]" do
      assert_select 'input[type=text]', 1
      assert_select 'input[type=email]', 1
      assert_select 'textarea', 1
      assert_select 'button', 'Just send me great music!'
    end

    # Create a user with name and email
    assert_difference -> { User.count }, 1 do
      post signup_start_url,
        params: { user: { name: 'Joe', email: 'test@example.com' } }
    end

    assert_response :redirect
    assert_redirected_to signup_welcome_path

    # User should exist, email is not confirmed
    user = User.find_by_email('test@example.com')
    assert_equal 'Joe', user.name
    assert_not user.confirmed_email

    token = user.access_tokens.first

    # Welcome email sent
    assert_select_email do
      assert_select 'h1', /Joe, /
      assert_select "a[href='#{token_url(token)}']", 'Confirm your email address'
    end

    # Welcome page shown
    follow_redirect!
    assert_response :success

    assert_select 'h1', 'Thanks for signing up!'

    # Simulate clicking on the token link from welcome email
    get token_url(token)
    assert_redirected_to admin_profile_path

    follow_redirect!
    assert_response :success

    # Showing my profile
    assert_select 'h1', 'Profile'
    assert_select 'h3', 'Joe'

    # Email now confirmed
    user.reload
    assert user.confirmed_email
  end
end
