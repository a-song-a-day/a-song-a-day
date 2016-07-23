class Admin::SubscriptionsController < Admin::AdminController
  def index
    @subscriptions = current_user.subscriptions.includes(:curator).order('created_at')
  end

  def destroy
    current_user.subscriptions.destroy(params[:id])

    redirect_to admin_subscriptions_path
  end
end
