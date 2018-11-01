class V1::EventsController < V1::BaseController

  before_action :set_location, only: [:index]
  before_action :authenticate_user!
  before_action :set_radius, only: [:index]
  before_action :set_query, only: [:index]
  before_action :set_event_by_id, except: [:index, :create]
  before_action :check_event_ownership, only: [:update, :destroy]

  def index
    @events = Event.within(@rad, origin: @loc)

    if @q
      @events = @events.search_full_text(@q)
    end
  end

  def show
  end

  def create
    @event = current_user.events.create(event_params)
    if !@event
      head 400
    elsif !@event.valid?
      render status: 422
    end
  end

  def destroy
    if !@event.destroy
      head 500
    end
    head 200
  end

  def update
    event_params.each do |k, v|
      @event.send k + "=", v
    end
    if !@event.save
      render status: 422
    end
  end

  # Implement error checking

  def sign_up
    if !current_user.attending.include? @event
      current_user.attending << @event
    end
  end

  def unsign_up
    if current_user.attending.include? @event
      current_user.attending.destroy @event
    end
  end

  def attending
  end

  private

  def check_event_ownership
    head 401 if @event.owner != current_user #&& != have admin functionality
  end

  def set_event_by_id
    @event = Event.find_by_id(params[:id] || params[:event_id])
    if !@event
      head 404
    end
  end

  def event_params
    params.require(:event).permit(:name, :description, :address, :contents)
  end

end
