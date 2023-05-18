class StudyTimesController < ApplicationController
  before_action :authenticate_user!

  def index
    @study_times = current_user.study_times
  end
end
