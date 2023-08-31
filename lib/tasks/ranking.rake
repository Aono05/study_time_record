namespace :ranking do
  desc "Update Ranking"
  task update_ranking: :environment do
    Rails.logger.info "Started update ranking. time: #{Time.current}"
    
    now = Time.current
    aggregation_started_at = now.ago(1.week).beginning_of_hour
    aggregation_ended_at = now.ago(1.hour).end_of_hour

    Ranking.create_total_week_duration_per_user(
      started_at: aggregation_started_at,
      ended_at: aggregation_ended_at
    )

    Rails.logger.info "Ended update ranking. time: #{Time.current}"
  end
end

