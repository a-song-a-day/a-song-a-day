require 'test_helper'

class ProfileTest < ActionDispatch::IntegrationTest
  def login_as(user)
    get token_url(user.access_tokens.create)
    assert_response :redirect
    assert_redirected_to admin_profile_path

    follow_redirect!
  end

  def assert_profile(user)
    assert_select '.user-profile', 1 do
      assert_select '.user-profile__name', user.name
      assert_select '.user-profile__email', user.email

      unless user.extra_information.blank?
        assert_select '.user-profile__extra-information', user.extra_information
      end

      user.social_links.each do |name, url|
        element = name.dasherize.downcase
        assert_select ".user-profile__#{element} a[href='#{url}']", name
      end
    end
  end

  test 'show user profile' do
    user = users(:alisdair)
    login_as user

    get admin_profile_path
    assert_response :success

    # Showing my profile
    assert_select 'h1', 'Profile'
    assert_profile user
  end

  test 'edit user profile' do
    user = users(:alisdair)
    login_as user

    get edit_admin_profile_path
    assert_response :success

    # Verify profile form
    assert_select "form[action='#{admin_profile_path}']" do
      assert_select "input[name='user[name]']", 1
      assert_select "input[name='user[email]']", 1
      assert_select "textarea[name='user[extra_information]']", 1
      assert_select "input[name='user[twitter_url]']", 1
      assert_select "input[name='user[instagram_url]']", 1
      assert_select "input[name='user[spotify_url]']", 1
      assert_select "input[name='user[soundcloud_url]']", 1
      assert_select 'button', 'Save profile'
    end

    patch admin_profile_path, params: {
      user: {
        name: 'Joe Cool Name',
        email: 'joe@cool.name',
        extra_information: 'I am cool',
        twitter_url: 'https://twitter.com/joecoolname',
        instagram_url: 'https://www.instagram.com/joecoolname',
        spotify_url: 'https://open.spotify.com/user/joecoolname',
        soundcloud_url: 'https://soundcloud.com/joecoolname',
      }
    }
    assert_redirected_to admin_profile_path

    user.reload
    assert_equal user.name, 'Joe Cool Name'
    assert_equal user.email, 'joe@cool.name'
    assert_equal user.extra_information, 'I am cool'
    assert_equal user.twitter_url, 'https://twitter.com/joecoolname'
    assert_equal user.instagram_url, 'https://www.instagram.com/joecoolname'
    assert_equal user.spotify_url, 'https://open.spotify.com/user/joecoolname'
    assert_equal user.soundcloud_url, 'https://soundcloud.com/joecoolname'

    follow_redirect!
    assert_response :success

    assert_select 'h1', 'Profile'
    assert_profile user
  end
end
