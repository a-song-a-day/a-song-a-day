class Genre < ApplicationRecord
  scope :primary, -> { where(primary: true) }
  scope :secondary, -> { where(primary: false) }

  has_many :curators, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
