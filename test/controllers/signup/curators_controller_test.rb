require 'test_helper'

class Signup::CuratorsControllerTest < ActionDispatch::IntegrationTest
  test 'signup curators page requires login' do
    get signup_curators_url
    assert_response :redirect
  end
end
