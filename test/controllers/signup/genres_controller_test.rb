require 'test_helper'

class Signup::GenresControllerTest < ActionDispatch::IntegrationTest
  test 'signup genres page requires login' do
    get signup_genres_url
    assert_response :redirect
  end
end
