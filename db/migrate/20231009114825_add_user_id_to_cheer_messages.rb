class AddUserIdToCheerMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :cheer_messages, :user_id, :integer, null: false
  end
end
