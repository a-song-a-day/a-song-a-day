class Admin::DailyMessagesController < Admin::AdminController

  def create
    resource.creator = current_user
    if resource.save
      redirect_to action: 'index'
    else
      render action: 'new'
    end
  end

  def update
    if resource.update_attributes(permitted_params)
      redirect_to action: 'index'
    else
      render action: 'edit'
    end
  end

  private
  def collection
    DailyMessage.all.order('send_at DESC')
  end
  helper_method :collection

  def resource
    if @resource
      return @resource
    end
    if params[:id]
      @resource = DailyMessage.find(params[:id])
    else
      @resource = DailyMessage.new(permitted_params)
    end
    @resource
  end
  helper_method :resource

  def permitted_params
    if params[:daily_message]
      params.require(:daily_message).permit(:send_at, :message)
    else
      {}
    end
  end
end
