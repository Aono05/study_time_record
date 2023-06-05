class StudyTime < ApplicationRecord
  belongs_to :user

  def duration
    (ended_at - started_at) / 60
  end


  private

  class << self
    def total_duration_per_day(user)
      StudyTime.group("date(started_at)").where(user: user).sum(calculate_duration)
    end

    def calculate_duration
      "(strftime('%s', ended_at) - strftime('%s', started_at)) / 60"
    end
  end
end
