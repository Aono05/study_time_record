class StudyTime < ApplicationRecord
  belongs_to :user
  validates :started_at, presence: true
  validates :ended_at, presence: true

  def duration
    return 0 if ended_at.nil?
    return 0 if ended_at < started_at

    (ended_at - started_at) / 60
  end

  class << self
    def total_duration_per_day(user)
      group("date(started_at)").where(user: user).sum(calculate_duration)
    end

    def where_by_duration(started_at, ended_at)
      where(started_at: started_at..ended_at)
    end

    private

    def calculate_duration
      "(strftime('%s', ended_at) - strftime('%s', started_at)) / 60"
    end
  end
end
