class Admin::DashboardController < Admin::AdminController
  before_action :require_admin
  def index
  end
end
