class Admin::ProfilesController < Admin::AdminController
  def show
  end

  def edit
    render "form"
  end

  def update
    if current_user.update(user_params)
      redirect_to admin_profile_path, notice: "Profile updated"
      return
    end

    render "form"
  end

  private

  def user_params
    # FIXME: should really reverify email once edited
    params.require(:user).permit(:name, :email, :extra_information)
  end
end
