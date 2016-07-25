class Admin::CuratorsController < Admin::AdminController
  before_action :require_curator
  before_action :find_curator, only: [:show, :edit, :update]

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
  end

  def edit
    render "form"
  end

  def update
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

  def find_curator
    if current_user.admin?
      @curator = Curator.find(params[:id])
    else
      @curator = current_user.curators.find(params[:id])
    end
  end
end
