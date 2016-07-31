class Song < ApplicationRecord
  include PgSearch

  pg_search_scope :search,
    against: [:title, :description],
    using: {
      tsearch: { prefix: true }
    }

  scope :queued, -> { where(sent_at: nil) }
  scope :sent, -> { where.not(sent_at: nil) }

  belongs_to :curator
  has_and_belongs_to_many :genres, -> { order('name') }

  validates_presence_of :url, :title, :description

  def append_sent_subscription_id(subscription_id)
    self.class.where(id: id).update_all([
      'sent_subscription_ids = array_append(sent_subscription_ids, ?)', subscription_id
    ])
  end
end
