class CreateRankings < ActiveRecord::Migration[5.2]
  def change
    create_table :rankings do |t|
      t.integer :total_duration, default: 0
      t.bigint :chunk_id, null: false
      t.timestamps
    end
  end
end
