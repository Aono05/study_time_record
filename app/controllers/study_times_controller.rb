class StudyTimesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_study_time, only: [:show, :edit, :update, :destroy]

  def index
    @study_times = current_user.study_times
  end

  def new
    @study_time = StudyTime.new
  end

  def create
    @study_time = StudyTime.new(study_time_params).tap do |study_time|
      study_time.user = current_user
    end

    if @study_time.save
      redirect_to @study_time
    else
      render 'new'
    end
  end

  def show
    @study_time = StudyTime.find(params[:id])
  end

  def edit
    @study_time = StudyTime.find(params[:id])
  end

  def update
    @study_time = StudyTime.find(params[:id])

    if @study_time.update(study_time_params)
      redirect_to @study_time
    else
      render 'edit'
    end
  end

  def destroy
    @study_time.destroy
    redirect_to study_times_path, notice: '勉強時間を削除しました'
  end


  private

  def study_time_params
    params.require(:study_time).permit(:started_at, :ended_at)
  end

  def set_study_time
    @study_time = current_user.study_times.find_by(id: params[:id])
  end
end
