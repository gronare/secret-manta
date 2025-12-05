class ChangeRequireWishlistDefault < ActiveRecord::Migration[8.1]
  def change
    change_column_default :events, :require_wishlist, from: false, to: true
  end
end
