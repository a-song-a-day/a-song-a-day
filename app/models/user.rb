class User < ApplicationRecord
  include PgSearch

  pg_search_scope :search,
    against: [:name, :email],
    using: {
      tsearch: { prefix: true }
    }

  scope :admin, -> { where(admin: true) }
  scope :curator, -> { where(curator: true) }

  has_many :access_tokens, dependent: :destroy
  has_many :curators, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true, on: [:create, :update]
  validates :email, presence: true, uniqueness: true

  def social_links
    %w(Twitter Instagram Spotify Soundcloud).map do |provider|
      url = attributes["#{provider.downcase}_url"]
      [provider, url] unless url.blank?
    end.compact
  end
end
