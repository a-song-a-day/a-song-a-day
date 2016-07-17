class Admin::MasqueradesController < Admin::AdminController
  before_action :require_admin, only: :create

  def create
    user = User.find(params[:user_id])

    session[:masquerade_user_id] = user.id

    redirect_to admin_profile_path
  end

  def destroy
    session.delete(:masquerade_user_id)

    redirect_to admin_dashboard_path
  end
end
