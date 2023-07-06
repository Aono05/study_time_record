class CreateRankings < ActiveRecord::Migration[5.2]
  def change
    create_table :rankings do |t|
      t.integer :user_id, null: false
      t.integer :total_duration, null: false
      t.bigint :chunk_id, null: false
      t.timestamps
    end
  end
end
