class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :curator

  validates_presence_of :user, :curator
  validates_uniqueness_of :curator, scope: :user
end
