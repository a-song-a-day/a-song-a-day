class Admin::UsersController < Admin::AdminController
  before_action :require_admin

  def index
    @users = User.order(created_at: :desc).page params[:page]
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

      redirect_to admin_user_path, notice: "User '#{@user.email}' created, welcome email sent"
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
      redirect_to admin_users_path, error: "Failed to delete user user '#{@user.email}'"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :extra_information, :curator, :admin)
  end
end
