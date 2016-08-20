class Genre < ApplicationRecord
  scope :primary, -> { where(primary: true) }
  scope :secondary, -> { where(primary: false) }

  has_and_belongs_to_many :curators, class_name: 'Curator', association_foreign_key: :curator_id
  has_and_belongs_to_many :songs

  validates :name, presence: true, uniqueness: true
end
