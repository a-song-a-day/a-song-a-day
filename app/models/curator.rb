class Curator < ApplicationRecord
  belongs_to :user
  has_many :songs, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :genre
  has_and_belongs_to_many :genres, -> { order('name') }

  validates_presence_of :user, :title, :description, :genre
  validates_uniqueness_of :random, conditions: -> { where(random: true) }

  scope :nonrandom, -> { where(random: false ) }

  def self.empty_queue
    left_outer_joins(:songs).where(songs: { sent_at: nil })
      .group('curators.id').having('count(songs.id) < 2')
  end

  def self.random
    where(random: true).first
  end

  def merge_and_delete!(other_curator)
    self.songs.update_all(curator_id: other_curator.id)
    self.subscriptions.update_all(curator_id: other_curator.id)
    self.delete
  end

  def next_song
    songs.queued.order(:created_at).first
  end

  def title_and_name
    "#{title} (#{user.name})"
  end
end
