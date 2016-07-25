class Admin::DashboardController < Admin::AdminController
  before_action :require_admin

  def index
    @queues = Curator.empty_queue.includes(:user).order(:title)
    @songs = Song.queued.order(created_at: :desc).includes(:genres, curator: :user)
  end
end
