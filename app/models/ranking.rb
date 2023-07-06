class Ranking < ApplicationRecord
  belongs_to :user

  class << self
    def create_total_week_duration_per_user
      Ranking.delete_all
      now = Time.current.to_i

      rank_data = User.all.map do |user|
        total_duration = StudyTime.total_duration_per_week(user)
        { user_id: user.id, total_duration: total_duration, chunk_id: now }
      end

      Ranking.import(rank_data)
    end

    def total_week_duration_latest
      where(chunk_id: maximum(:chunk_id)).order(total_duration: :desc)
    end
  end
end
