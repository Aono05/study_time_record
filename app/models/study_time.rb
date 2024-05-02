class StudyTime < ApplicationRecord
  belongs_to :user
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :memo, ngword: true

  def duration
    return 0 if ended_at.nil?
    return 0 if ended_at < started_at

    (ended_at - started_at) / 60
  end

  def before_started_on?(based_on)
    started_at.to_date == based_on.ago(1.day).to_date
  end

  class << self
    def total_duration_for_user(user)
      where(user: user).sum(&:duration)
    end

    def calculate_consecutive_days(user)
      consecutive_days = 0
      consecutive_calculated_on = Time.current.to_date

      # TODO: パフォーマンスに懸念があるため改善する
      where(user_id: user.id).order(started_at: :desc).each do |study_time|

        break if consecutive_calculated_on != study_time.started_at.to_date

        consecutive_days += 1
        consecutive_calculated_on = consecutive_calculated_on.ago(1.day).to_date
      end

      consecutive_days
    end

    def max_consecutive_days_for_user(user)
      consecutive_days = 0
      max_consecutive_days = 0
      consecutive_calculated_on = Time.current.to_date

      # TODO: パフォーマンスに懸念があるため改善する
      where(user_id: user.id).order(started_at: :desc).each do |study_time|
        study_started_on = study_time.started_at.to_date

        if study_time.before_started_on?(consecutive_calculated_on)
          consecutive_days += 1
        else
          consecutive_days = 1
        end

        max_consecutive_days = [max_consecutive_days, consecutive_days].max
        consecutive_calculated_on = study_started_on
      end

      max_consecutive_days
    end

    def total_duration_per_day(user)
      group("to_char(started_at AT TIME ZONE 'UTC', 'YYYY-MM-DD')").where(user: user).sum(calculate_duration)
    end

    def where_by_duration(started_at, ended_at)
      where(started_at: started_at..ended_at)
    end

    private

    def calculate_duration
      "EXTRACT(EPOCH FROM (ended_at - started_at)) / 60"
    end
  end
end
