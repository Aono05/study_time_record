class CreateCheerMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :cheer_messages do |t|
      t.string :content
      t.timestamps
    end
  end
end
