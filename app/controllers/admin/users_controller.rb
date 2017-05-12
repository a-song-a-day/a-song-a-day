class Admin::UsersController < Admin::AdminController
  before_action :require_admin

  def index
    @search = params[:q]
    @users = User.all
    @users = @users.search(@search) unless @search.blank?
    @users = @users.order(created_at: :desc)
    respond_to do |format|
      format.html { @users = @users.page(params[:page]) }
      format.csv { send_data @users.to_csv, filename: "users-#{Date.today}.csv" }
    end
  end

  def new
    @user = User.new

    render "form"
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.subscriptions.create(curator: Curator.random)
      token = @user.access_tokens.create!

      TransactionalMailer.welcome(@user, token).deliver

      redirect_to admin_users_path, notice: "User '#{@user.email}' created, welcome email sent"
      return
    end

    render "form"
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])

    render "form"
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User '#{@user.email}' updated"
      return
    end

    render "form"
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      redirect_to admin_users_path, notice: "User '#{@user.email}' deleted"
    else
      redirect_to admin_users_path, error: "Failed to delete user '#{@user.email}'"
    end
  end

  private

  def user_params
    # TODO remove the admin param, only allow via console
    params.require(:user).permit(:name, :email, :extra_information, :curator, :admin, :bounced,
                                 :twitter_url, :instagram_url, :spotify_url,
                                 :soundcloud_url)
  end
end
