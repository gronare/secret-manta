class AddStatusAndConfigurationToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :status, :string, default: "draft", null: false
    add_index :events, :status

    add_column :events, :theme, :string, default: "christmas"

    add_column :events, :require_rsvp, :boolean, default: false, null: false
    add_column :events, :require_address, :boolean, default: false, null: false
    add_column :events, :require_wishlist, :boolean, default: false, null: false

    add_column :events, :organizer_participates, :boolean, default: true, null: false

    add_column :events, :launched_at, :datetime

    reversible do |dir|
      dir.up do
        Event.update_all(status: "active", launched_at: Time.current)
      end
    end
  end
end
