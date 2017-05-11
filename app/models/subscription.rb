class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :curator

  validates_presence_of :user, :curator
  validates_uniqueness_of :curator, scope: :user

  def unsubscribe_token
    @token ||= user.access_tokens.unexpired_for_two_weeks.find_or_create.token
  end
end
