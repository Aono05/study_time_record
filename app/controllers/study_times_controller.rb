class StudyTimesController < ApplicationController
  before_action :authenticate_user!

  def index
    @study_times = current_user.study_times
  end

  def new
    @study_time = StudyTime.new
  end

  def create
    @study_time = StudyTime.new(study_time_params)
    @study_time.user = current_user

    if @study_time.save
      redirect_to @study_time
    else
      render 'new'
    end
  end


  private

  def study_time_params
    params.require(:study_time).permit(:start_time, :end_time)
  end
end
