class Song < ApplicationRecord
  include PgSearch

  pg_search_scope :search,
    against: [:title, :description],
    using: {
      tsearch: { prefix: true }
    }

  scope :queued, -> { where(sent_at: nil) }
  scope :sent, -> { where.not(sent_at: nil) }
  scope :positioned, -> { order(position: :desc) }

  belongs_to :curator
  has_and_belongs_to_many :genres, -> { order('name') }

  validates_presence_of :url, :title, :description

  before_create :set_position

  def append_sent_subscription_id(subscription_id)
    self.class.where(id: id).update_all([
      'sent_subscription_ids = array_append(sent_subscription_ids, ?)', subscription_id
    ])
  end

  def sent!
    update(sent_at: Time.now)
  end

  def set_position
    self.position = curator.songs.maximum(:position).to_i + 1
  end

  def reposition!(new_position)
    if new_position.to_i < position.to_i
      curator.songs.where(position: new_position..position).map{|s| s.update_attribute(:position, s.position + 1) }
    else
      curator.songs.where(position: position..new_position).map{|s| s.update_attribute(:position, s.position - 1) }
    end
    self.update_attribute(:position, new_position)
  end
end
