class User < ApplicationRecord
  include PgSearch

  pg_search_scope :search,
    against: [:name, :email],
    using: {
      tsearch: { prefix: true }
    }

  has_many :access_tokens, dependent: :destroy
  has_many :curators, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true, on: [:create, :update]
  validates :email, presence: true, uniqueness: true

  def social_links?
    %w(twitter_url instagram_url spotify_url soundcloud_url).any? do |url|
      attributes[url].present?
    end
  end

  def social_url(social)
    attributes["#{social.downcase}_url"]
  end
end
