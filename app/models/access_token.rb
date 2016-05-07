class AccessToken < ApplicationRecord
  scope :unexpired, -> { where("NOW() - updated_at < INTERVAL '4 weeks'") }

  belongs_to :user

  before_validation :generate_token, on: :create

  validates_presence_of :user, :token
  validates_uniqueness_of :token

  protected

  def generate_token
    self.token = SecureRandom.hex(16)
  end
end
