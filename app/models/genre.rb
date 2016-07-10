class Genre < ApplicationRecord
  class << self
    def primary
      where(primary: true)
    end

    def secondary
      where(primary: false)
    end
  end

  validates :name, presence: true, uniqueness: true
end
