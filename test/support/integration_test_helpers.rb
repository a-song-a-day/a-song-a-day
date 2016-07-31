module IntegrationTestHelpers
  def login_as(user)
    get token_url(user.access_tokens.create)
    assert_response :redirect
    assert_redirected_to admin_profile_path

    follow_redirect!
  end
end
