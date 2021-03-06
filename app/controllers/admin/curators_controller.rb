class Admin::CuratorsController < Admin::AdminController
  before_action :require_curator
  before_action :find_curators
  before_action :find_curator, only: [:show, :edit, :update, :merge]
  before_action :require_admin, only: [:merge]

  def index
    @curators = @curators.order(:title)

    case @curators.count
    when 0 then redirect_to new_admin_curator_path
    when 1 then redirect_to admin_curator_path(@curators.first)
    end
  end

  def new
    @curator = @curators.build

    render "form"
  end

  def create
    @curator = @curators.build(curator_params)

    if params[:commit] and @curator.save
      redirect_to admin_curator_path(@curator)
      return
    end

    render "form"
  end

  def show
    # Our job queues sends at midday UTC
    @next_send = Time.now.utc.hour < 12 ? Date.today : Date.tomorrow

    # Skip weekends
    @next_send = @next_send.next_weekday if @next_send.on_weekend?
  end

  def edit
    render "form"
  end

  def update
    @curator.attributes = curator_params

    if params[:commit] and @curator.save
      genre = @curator.genre
      @curator.genres << genre unless @curator.genres.include? genre
      redirect_to admin_curator_path(@curator), notice: "Curator profile updated"
      return
    end

    render "form"
  end

  def merge
    if request.get?
      return
    end
    @other_curator = find_curators.where(id: params[:other_curator_id]).first
    if @other_curator.nil?
      return
    end
    @curator.merge_and_delete!(@other_curator)
    redirect_to action: 'show', id: @other_curator.id
  end

  private

  def curator_params
    permitted = [:title, :description, :genre_id, genre_ids: []]
    permitted.unshift :user_id if current_user.admin?
    params.require(:curator).permit(permitted)
  end

  def find_curators
    if current_user.admin?
      @curators = Curator.all
    else
      @curators = current_user.curators
    end
  end

  def find_curator
    @curator = @curators.find(params[:id])
  end
end
