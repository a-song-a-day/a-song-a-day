class Admin::SubscriptionsController < Admin::AdminController
  def index
    @subscriptions = current_user.subscriptions.includes(:curator).order('created_at')
  end

  def create
    @subscription = current_user.subscriptions.build(subscription_params)

    if @subscription.save
      redirect_to admin_subscriptions_path
      return
    end

    redirect_to admin_subscriptions_path, alert: "Couldn't create subscription :("
  end

  def destroy
    current_user.subscriptions.destroy(params[:id])

    redirect_to admin_subscriptions_path
  end

  private

  def subscription_params
    params.require(:subscription).permit(:curator_id)
  end
end
