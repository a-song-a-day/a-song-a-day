class Curator < ApplicationRecord
  belongs_to :user
  has_many :songs, -> { order('created_at DESC') }

  validates_presence_of :user, :title, :description
  validates_uniqueness_of :random, conditions: -> { where(random: true) }

  def self.random
    where(random: true).first
  end
end
