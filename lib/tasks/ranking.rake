namespace :ranking do
  desc "Update Ranking"
  task update_ranking: :environment do
    Ranking.create_total_week_duration_per_user
  end
end
