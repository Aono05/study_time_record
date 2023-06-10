class StudyTime < ApplicationRecord
  belongs_to :user

  def duration
    (ended_at - started_at) / 60
  end
end
