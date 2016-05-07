class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :curator

  validates_presence_of :user, :curator
end
