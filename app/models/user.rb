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
end
