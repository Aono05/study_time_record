class Ranking < ApplicationRecord
  belongs_to :user

  class << self
    def create_total_week_duration_per_user(started_at:, ended_at:)
      chunk_id = aggregation_chunk_id(started_at)

      results = {}
      StudyTime.where_by_duration(
        started_at,
        ended_at
      ).find_each do |study_time|
        aggregated_total_duration = results[study_time.user_id]

        results[study_time.user_id] = if aggregated_total_duration.nil?
          study_time.duration
        else
          aggregated_total_duration + study_time.duration
        end
      end

      rankings = results.map do |user_id, total_duration|
        {
          user_id: user_id,
          chunk_id: chunk_id,
          total_duration: total_duration.to_i
        }
      end

      import!(rankings)
    end

    def total_week_duration_latest
      where(chunk_id: maximum(:chunk_id)).order(total_duration: :desc)
    end

    private

    def aggregation_chunk_id(aggregation_time)
      aggregation_time.to_i
    end
  end
end
