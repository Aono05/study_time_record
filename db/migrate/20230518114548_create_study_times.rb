class CreateStudyTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :study_times do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :user_id

      t.timestamps
    end
  end
end
