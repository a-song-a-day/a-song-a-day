require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'home page works' do
    get root_url
    assert_response :success
  end
end
