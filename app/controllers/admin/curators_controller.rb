class Admin::CuratorsController < Admin::AdminController
  before_action :require_curator

  def index
  end
end
