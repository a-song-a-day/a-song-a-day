class AccessToken < ApplicationRecord
  scope :unexpired, -> { where("NOW() - updated_at < INTERVAL '4 weeks'") }

  belongs_to :user

  before_validation :generate_token, on: :create

  validates_presence_of :user, :token
  validates_uniqueness_of :token

  def self.from_param(token)
    unexpired.where(token: token).first!
  end

  def to_param
    token
  end

  protected

  def generate_token
    self.token = SecureRandom.hex(16)
  end
end
