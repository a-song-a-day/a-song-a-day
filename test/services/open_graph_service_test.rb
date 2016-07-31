require 'test_helper'
require 'minitest/mock'

class OpenGraphServiceTest < ActiveSupport::TestCase
  test 'successful fetch' do
    song = Song.new(url: 'https://www.youtube.com/watch?v=9EcjWd-O4jI')

    success = Proc.new do |url|
      assert_equal song.url, url
      OpenGraph::Object.new({
        title: 'Technotronic - Pump Up The Jam',
        image: 'https://i.ytimg.com/vi/9EcjWd-O4jI/maxresdefault.jpg',
      })
    end

    OpenGraph.stub :fetch, success do
      OpenGraphService.perform(song)

      assert_equal 'Technotronic - Pump Up The Jam', song.title
      assert_equal 'https://i.ytimg.com/vi/9EcjWd-O4jI/maxresdefault.jpg', song.image_url
    end
  end

  test 'no results found' do
    song = Song.new(url: 'http://youtube.com')

    no_results = Proc.new do |url|
      assert_equal song.url, url
      false
    end

    OpenGraph.stub :fetch, no_results do
      OpenGraphService.perform(song)

      assert_equal nil, song.title
      assert_equal nil, song.image_url
    end
  end

  test 'exception thrown' do
    song = Song.new(url: '')

    failure = Proc.new do |url|
      assert_equal song.url, s
      fail 'whoops'
    end

    Rails.logger.stub :debug, nil do
      OpenGraph.stub :fetch, failure do
        OpenGraphService.perform(song)

        assert_equal nil, song.title
        assert_equal nil, song.image_url
      end
    end
  end
end
