class DailyMessage < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  validates_presence_of :message
  validates_uniqueness_of :send_at, allow_nil: true
end
