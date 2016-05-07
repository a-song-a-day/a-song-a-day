class Curator < ApplicationRecord
  belongs_to :user

  validates_presence_of :user, :title, :description
end
