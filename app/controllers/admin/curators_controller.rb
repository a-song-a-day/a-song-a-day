class Admin::CuratorsController < Admin::AdminController
  before_action :require_curator

  def index
    @curators = current_user.curators.order(title: :desc)

    case @curators.count
    when 0 then redirect_to new_admin_curator_path
    when 1 then redirect_to admin_curator_path(@curators.first)
    end
  end

  def new
    @curator = current_user.curators.build

    render "form"
  end

  def create
    @curator = current_user.curators.build(curator_params)

    if @curator.save
      redirect_to admin_curator_path(@curator)
      return
    end

    render "form"
  end

  def show
    @curator = current_user.curators.find(params[:id])
  end

  def edit
    @curator = current_user.curators.find(params[:id])

    render "form"
  end

  def update
    @curator = current_user.curators.find(params[:id])

    if @curator.update(curator_params)
      redirect_to admin_curator_path(@curator), notice: "Curator profile updated"
      return
    end

    render "form"
  end

  private

  def curator_params
    params.require(:curator).permit(:title, :description, :genre_id, genre_ids: [])
  end
end
