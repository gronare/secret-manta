class ParticipantsController < ApplicationController
  before_action :set_event

  def create
    @participant = @event.participants.build(participant_params)

    if @participant.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to organize_event_path(@event), notice: "Participant added successfully!" }
      end
    else
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("participant_form",
            partial: "participants/form",
            locals: { event: @event, participant: @participant })
        }
        format.html { redirect_to organize_event_path(@event), alert: "Failed to add participant." }
      end
    end
  end

  def destroy
    @participant = @event.participants.find(params[:id])
    @participant.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to organize_event_path(@event), notice: "Participant removed." }
    end
  end

  private

  def set_event
    @event = Event.find_by!(slug: params[:event_id])
  end

  def participant_params
    params.require(:participant).permit(:name, :email)
  end
end
