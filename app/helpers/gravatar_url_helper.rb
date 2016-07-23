require 'digest/md5'

module GravatarUrlHelper
  def gravatar_url(email)
    hash = Digest::MD5.hexdigest(email.downcase)
    "https://www.gravatar.com/avatar/#{hash}?s=400&d=blank"
  end
end
