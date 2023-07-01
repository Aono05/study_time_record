namespace :ranking do
  desc "Ranking"
  task ranking_update: :environment do
    StudyTime.total_duration_per_week_per_user
    study_times = StudyTime.total_duration_per_week_per_user
    p study_times
    puts "Rankingを更新しました"
  end
end
