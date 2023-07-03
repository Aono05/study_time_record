class Ranking < ApplicationRecord
  class << self
    def create_total_week_duration_per_user
      total_study_time_per_user = StudyTime.total_duration_per_week_per_user
      now = Time.current.to_i
      total_study_time_per_user.each do |user_id, total_study_time|
        user = User.find(user_id.id)

        create(
          user_id: user_id.id,
          total_duration: total_study_time_per_user,
          chunk_id: now
        )
      end
    end

    def total_week_duration_latest
      where(chunk_id: maximum(:chunk_id)).order(total_duration: :desc)
    end
  end
end
