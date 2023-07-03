class RankingsController < ApplicationController
  def index
    @total_week_study_time_ranking = Ranking.total_week_duration_latest
  end
end
