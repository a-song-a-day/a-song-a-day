require 'test_helper'

class Signup::WelcomeControllerTest < ActionDispatch::IntegrationTest
  test 'signup welcome page requires login' do
    get signup_welcome_url
    assert_response :redirect
  end
end
