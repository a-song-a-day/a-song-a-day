class Curator < ApplicationRecord
  belongs_to :user
  has_many :songs, -> { order('created_at DESC') }
  has_many :subscriptions, -> { order('created_at DESC') }
  belongs_to :genre
  has_and_belongs_to_many :genres, -> { order('name') }

  validates_presence_of :user, :title, :description, :genre
  validates_uniqueness_of :random, conditions: -> { where(random: true) }

  def self.random
    where(random: true).first
  end

  def title_and_name
    "#{title} (#{user.name})"
  end
end
