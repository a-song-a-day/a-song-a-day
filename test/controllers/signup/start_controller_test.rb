require 'test_helper'

class Signup::StartControllerTest < ActionDispatch::IntegrationTest
  test 'signup start page works' do
    get signup_start_url
    assert_response :success
  end
end
