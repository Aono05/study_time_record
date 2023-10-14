class AddImageToCheerMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :cheer_messages, :image, :string
  end
end
