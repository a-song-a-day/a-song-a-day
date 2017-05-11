require 'csv'

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
  validates :twitter_url, :instagram_url, :spotify_url, :soundcloud_url,
    url: true, allow_blank: true

  def self.to_csv
    CSV.generate(headers: true, encoding: 'utf-8') do |csv|
      csv << attribute_names

      all.each {|user| csv << user.attributes }
    end
  end

  def social_links
    %w(Twitter Instagram Spotify Soundcloud).map do |provider|
      url = attributes["#{provider.downcase}_url"]
      [provider, url] unless url.blank?
    end.compact
  end

  def subscribed_to?(curator)
    subscriptions.where(curator_id: curator.id).exists?
  end
end
