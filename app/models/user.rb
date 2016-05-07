class User < ApplicationRecord
  has_many :access_tokens, dependent: :destroy
  has_many :curators, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates_presence_of :name, :email
  validates_uniqueness_of :email
end
