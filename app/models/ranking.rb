class Ranking < ApplicationRecord
  belongs_to :user

  class << self
    def create_total_week_duration_per_user
      Ranking.delete_all
      now = Time.current.to_i

      User.all.each do |user|
        total_duration = StudyTime.total_duration_per_week(user)
        Ranking.create(user: user, total_duration: total_duration, chunk_id: now)
      end
    end

    def total_week_duration_latest
      where(chunk_id: maximum(:chunk_id)).order(total_duration: :desc)
    end
  end
end
