class Admin::SubscriptionsController < Admin::AdminController
  before_action :find_user

  def index
    @subscriptions = @user.subscriptions.includes(:curator).order('created_at')
  end

  def create
    @subscription = @user.subscriptions.build(subscription_params)

    if @subscription.save
      SubscriptionMailer.created(@subscription).deliver
      redirect_to action: :index
      return
    end

    redirect_to action: :index, alert: "Couldn't create subscription :("
  end

  def destroy
    @subscription = @user.subscriptions.find(params[:id])

    if @subscription.destroy
      SubscriptionMailer.destroyed(@subscription).deliver
    end

    redirect_to action: :index
  end

  private

  def find_user
    if params[:user_id]
      require_admin
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
  end

  def subscription_params
    params.require(:subscription).permit(:curator_id)
  end
end
