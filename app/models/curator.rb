class Curator < ApplicationRecord
  belongs_to :user

  validates_presence_of :user, :title, :description
  validates_uniqueness_of :random, conditions: -> { where(random: true) }

  def self.random
    where(random: true).first
  end
end
