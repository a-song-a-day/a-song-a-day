require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest
  test 'can sign up through home page' do
    get '/'
    assert_response :success

    assert_select "form[action='#{signup_start_url}'][method=get]", 2 do |forms|
      forms.each do |form|
        assert_select form, 'input[type=email]'
        assert_select form, 'button', 'Sign Up'
      end
    end

    get signup_start_url(email: 'test@example.com')
    assert_response :success

    assert_select "form[action='#{signup_start_url}'][method=post]" do
      assert_select 'input[type=text]', 1
      assert_select 'input[type=email]', 1
      assert_select 'textarea', 1
      assert_select 'button', 'Send me great music!'
    end

    assert_difference -> { User.count }, 1 do
      post signup_start_url,
        params: { user: { name: 'Joe', email: 'test@example.com' } }
    end
    assert_response :redirect

    user = User.find_by_email('test@example.com')
    assert_equal 'Joe', user.name
    assert_not user.confirmed_email

    token = user.access_tokens.first

    assert_select_email do
      assert_select 'h1', "Joe, it's almost time for music!"
      assert_select "a[href='#{token_url(token)}']", 'Confirm your email address'
    end

    follow_redirect!
    assert_response :success

    assert_select 'h1', 'Thanks for signing up!'

    visit token_url(token)

    user.reload!
    assert 'Joe', user.conf
  end
end
