class Ranking < ApplicationRecord
  belongs_to :user

  def set_duration
    study_times = user.study_times
    self.duration = study_times.sum(&:duration)
    save
  end

  def self.total_duration_per_week_per_user
    select("users.id, SUM(rankings.duration) AS total_duration")
      .joins(:user)
      .where("rankings.created_at >= ?", 1.week.ago)
      .group("users.id")
      .order("total_duration DESC")
  end
end
