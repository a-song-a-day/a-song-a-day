class OpenGraphService
  def self.perform(song)
    result = OpenGraph.fetch(song.url)

    song.attributes = {
      title: result.title,
      image_url: result.image
    } if result
  rescue => e
    Rails.logger.debug "OpenGraph fetch failed for #{song.url}"
    Rails.logger.debug e
  end
end
