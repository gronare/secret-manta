class EventsController < ApplicationController
  before_action :set_event, only: [ :show, :organize, :draw_assignments ]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      # Create organizer as first participant
      organizer = @event.participants.create!(
        name: @event.organizer_name,
        email: @event.organizer_email,
        is_organizer: true
      )

      # Set Current for tracking
      Current.participant = organizer
      Current.event = @event

      redirect_to organize_event_path(@event), notice: "Event created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # HEY pattern: Access Current directly, no helper method
    @participant = Current.participant
  end

  def organize
    # Modern Rails: Strict loading prevents N+1, includes for eager loading
    @participants = @event.participants.strict_loading(false).order(created_at: :asc)
  end

  def draw_assignments
    # HEY pattern: Service object handles complex business logic
    SecretSanta::AssignmentService.new(@event).call

    respond_to do |format|
      format.html { redirect_to organize_event_path(@event), notice: "Assignments drawn! Participants can now view their assignments." }
      format.turbo_stream
    end
  rescue SecretSanta::AssignmentService::InsufficientParticipantsError => e
    redirect_to organize_event_path(@event), alert: e.message
  rescue SecretSanta::AssignmentService::AlreadyAssignedError => e
    redirect_to organize_event_path(@event), alert: e.message
  end

  private

  def set_event
    # Modern Rails: includes for eager loading associations
    @event = Event.includes(:participants).find_by!(slug: params[:id])
    Current.event = @event
  end

  def event_params
    params.require(:event).permit(
      :name,
      :event_date,
      :location,
      :budget,
      :description,
      :organizer_name,
      :organizer_email
    )
  end
end
