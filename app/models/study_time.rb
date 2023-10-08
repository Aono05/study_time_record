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

  class << self
    def total_duration_for_user(user)
      where(user: user).sum(&:duration)
    end

    def calculate_consecutive_days(user)
      consecutive_days = 0
      consecutive_calcurated_on = Time.current.to_date

      where(user_id: user.id).order(started_at: :desc).find_each do |study_time|

        break if consecutive_calcurated_on != study_time.started_at.to_date

        consecutive_days += 1
        consecutive_calcurated_on = consecutive_calcurated_on.ago(1.day).to_date
      end

      consecutive_days
    end

    def max_consecutive_days_for_user(user)
      consecutive_days = 0
      max_consecutive_days = 0
      consecutive_calcurated_on = Time.current.to_date
      loop_count = 0

      where(user_id: user.id).order(started_at: :desc).find_each do |study_time|
        study_started_on = study_time.started_at.to_date

        if (consecutive_calcurated_on - study_started_on).to_i == 1
          consecutive_days += 1
        else
          consecutive_days = 1
        end

        max_consecutive_days = [max_consecutive_days, consecutive_days].max
        consecutive_calcurated_on = study_started_on

        loop_count += 1
        puts "ループ回数: #{loop_count}"
        puts "最大の連続勉強日数: #{max_consecutive_days}"
        puts "連続勉強日数の計算日: #{consecutive_calcurated_on}"


      end

      max_consecutive_days
    end

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
