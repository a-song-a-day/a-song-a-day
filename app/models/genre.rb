class Genre < ApplicationRecord
  scope :primary, -> { where(primary: true) }
  scope :secondary, -> { where(primary: false) }

  has_many :curators, dependent: :nullify
  has_and_belongs_to_many :curators

  validates :name, presence: true, uniqueness: true
end
