class Song < ApplicationRecord
  scope :queued, -> { where(sent_at: nil) }
  scope :sent, -> { where.not(sent_at: nil) }

  belongs_to :curator
  validates_presence_of :url, :title, :description
end
