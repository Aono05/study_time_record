class CreateStudyTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :study_times do |t|
      t.datetime :started_at, null: false
      t.datetime :ended_at, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
