class RemoveUnusedSettingsFromEvents < ActiveRecord::Migration[8.1]
  def change
    remove_column :events, :require_rsvp, :boolean, if_exists: true
    remove_column :events, :require_address, :boolean, if_exists: true
    remove_column :events, :require_wishlist, :boolean, if_exists: true
  end
end
