require 'test_helper'

class GenreTest < ActiveSupport::TestCase
  test 'can create' do
    assert_difference -> { Genre.count }, 1 do
      subscription = Genre.create(name: 'Rock & Roll')
    end
  end
end
