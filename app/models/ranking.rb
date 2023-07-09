class Ranking < ApplicationRecord
  belongs_to :user

  class << self
    def create_total_week_duration_per_user
      now = Time.current
      chunk_id = now.to_i

      rankings = StudyTime
        .total_duration_per_user(now.ago(1.week), now)
        .map do |user_id, total_duration|
          { user_id: user_id, total_duration: total_duration, chunk_id: chunk_id }
        end

      Ranking.import(rankings)
      end

    def total_week_duration_latest
      where(chunk_id: maximum(:chunk_id)).order(total_duration: :desc)
    end
  end
end
