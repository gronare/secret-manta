class SessionsController < ApplicationController
  # Modern Rails: Using generates_token_for for magic link authentication
  skip_before_action :set_current_participant, only: [ :new, :create, :authenticate ]

  def new
    # Show email input for magic link
  end

  def create
    @participant = Participant.find_by(email: params[:email]&.strip&.downcase)

    if @participant
      # Modern Rails: generates_token_for creates secure, expiring tokens
      token = @participant.generate_token_for(:magic_link)
      magic_link = auth_url(token)

      # Send magic link via email (will implement mailer next)
      # ParticipantMailer.magic_link(@participant, magic_link).deliver_later

      redirect_to root_path, notice: "Check your email for a magic link to sign in!"
    else
      redirect_to new_session_path, alert: "Email not found. Please check your email address."
    end
  end

  def authenticate
    @participant = Participant.find_by_token_for(:magic_link, params[:token])

    if @participant
      session[:participant_id] = @participant.id
      Current.participant = @participant

      redirect_path = @participant.organizer? ? organize_event_path(@participant.event) : event_path(@participant.event)
      redirect_to redirect_path, notice: "Successfully signed in!"
      return
    end

    Event.find_each do |event|
      if event.find_by_token_for(:organizer_access, params[:token])
        organizer = event.organizer
        if organizer
          session[:participant_id] = organizer.id
          Current.participant = organizer
          redirect_to organize_event_path(event), notice: "Welcome back!"
          return
        end
      end
    end

    redirect_to root_path, alert: "Invalid or expired magic link. Please request a new one."
  end

  def destroy
    session.delete(:participant_id)
    Current.participant = nil

    redirect_to root_path, notice: "Successfully signed out!"
  end
end
