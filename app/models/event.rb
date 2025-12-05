class Event < ApplicationRecord
  has_many :participants, dependent: :destroy, strict_loading: true

  normalizes :organizer_email, with: ->(email) { email.strip.downcase }

  enum :status, { draft: "draft", active: "active", completed: "completed" }, default: :draft

  validates :name, presence: true
  validates :organizer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :organizer_name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :status, presence: true
  validates :theme, inclusion: { in: %w[christmas hanukkah winter generic] }, allow_nil: true

  generates_token_for :organizer_access, expires_in: 24.hours

  before_validation :generate_slug, on: :create

  scope :recent, -> { order(created_at: :desc) }
  scope :upcoming, -> { where("event_date >= ?", Date.current).order(:event_date) }

  def to_param
    slug
  end

  def organizer
    participants.find_by(is_organizer: true)
  end

  def ready_to_launch?
    return false if active? || completed?
    participants.count >= 3
  end

  def assignments_drawn?
    participants.where.not(assigned_to_id: nil).exists?
  end

  def launch!
    return false unless ready_to_launch?

    transaction do
      update!(status: :active, launched_at: Time.current)
      true
    end
  end

  private

  def generate_slug
    self.slug ||= SecureRandom.urlsafe_base64(8)
  end
end
