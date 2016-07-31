require 'test_helper'
require_relative '../support/integration_test_helpers'

class CuratorsTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpers

  test 'show curator profile' do
    user = users(:janet)
    curator = user.curators.first

    login_as user

    # Login normally takes you to the profile page
    get admin_profile_path
    assert_response :success

    # Curators have a "Curate" nav link to the curators page
    assert_select ".nav-link[href='#{admin_curators_path}']", 'Curate'

    # If the curator has one profile, redirect to it
    get admin_curators_path
    assert_redirected_to admin_curator_path(curator)

    follow_redirect!
    assert_response :success
    assert_select 'h1', curator.title
  end

  test 'edit curator profile' do
    user = users(:janet)
    curator = user.curators.first
    login_as user

    get edit_admin_curator_path(curator)
    assert_response :success

    # Verify curator profile form
    assert_select "form[action='#{admin_curator_path(curator)}']" do
      assert_select "input[name='curator[title]']", 1
      assert_select "textarea[name='curator[description]']", 1
      assert_select "select[name='curator[genre_id]']", 1
      assert_select '.option input[type=checkbox]', Genre.count
      assert_select "input[type=submit][value=Preview][name=preview]"
      assert_select "input[type=submit][value='Save curator profile'][name=commit]"
    end

    patch admin_curator_path(curator), params: {
      curator: {
        title: 'Neo Classical',
        description: 'Old but new?',
        genre_id: genres(:pop).id,
        genre_ids: [ '', genres(:classical).id ]
      },
      commit: 'Save curator profile'
    }
    assert_redirected_to admin_curator_path(curator)

    curator.reload
    assert_equal curator.title, 'Neo Classical'
    assert_equal curator.description, 'Old but new?'
    assert_equal curator.genre, genres(:pop)
    assert_equal curator.genres, [ genres(:classical) ]

    follow_redirect!
    assert_response :success

    assert_select 'h1', curator.title
  end

  test 'edit user profile: validation error' do
    user = users(:janet)
    curator = user.curators.first
    login_as user

    get edit_admin_curator_path(curator)
    assert_response :success

    # Verify curator profile form
    assert_select "form[action='#{admin_curator_path(curator)}']" do
      assert_select "input[name='curator[title]']", 1
      assert_select "textarea[name='curator[description]']", 1
      assert_select "select[name='curator[genre_id]']", 1
      assert_select '.option input[type=checkbox]', Genre.count
      assert_select "input[type=submit][value=Preview][name=preview]"
      assert_select "input[type=submit][value='Save curator profile'][name=commit]"
    end

    patch admin_curator_path(curator), params: {
      curator: {
        title: '',
        description: '',
        genre_id: '',
        genre_ids: [ '', genres(:classical).id ]
      },
      commit: 'Save curator profile'
    }

    assert_response :success
    assert_select 'h1', 'Edit Curator Profile'
    assert_select "form[action='#{admin_curator_path(curator)}']" do
      assert_select ".has-danger input[name='curator[title]']", 1
      assert_select ".has-danger textarea[name='curator[description]']", 1
      assert_select ".has-danger select[name='curator[genre_id]']", 1
    end

    curator.reload
    assert_equal curator.title, 'Classical and Indie Smash'
    assert_equal curator.description, 'Modern classical plus chamber pop, art rock, and genre-benders.'
    assert_equal curator.genre, genres(:classical)
  end
end
