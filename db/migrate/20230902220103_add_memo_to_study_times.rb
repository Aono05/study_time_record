class AddMemoToStudyTimes < ActiveRecord::Migration[5.2]
  def change
    add_column :study_times, :memo, :string
  end
end
