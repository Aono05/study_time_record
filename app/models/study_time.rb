class StudyTime < ApplicationRecord
  belongs_to :user

  def duration
    (end_time - start_time) / 60
  end
end
