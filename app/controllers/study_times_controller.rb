class StudyTimesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_study_time, only: [:show, :edit, :update, :destroy]

  def index
    @random_cheer_message = CheerMessage.random(current_user)
    @total_study_time_indexed_by_date = StudyTime.total_duration_per_day(current_user)
    @study_times = current_user.study_times.order(started_at: :asc)
  end

  def new
    @study_time = StudyTime.new
  end

  def create
    @study_time = current_user.study_times.build(study_time_params)

    if @study_time.save
      redirect_to @study_time
    else
      render 'new'
    end
  end

  def show
    if @study_time.present?
      render :show
    else
      redirect_to study_times_path, notice: '指定された勉強時間が見つかりません'
    end
  end

  def edit
  end

  def update
    if @study_time.update!(study_time_params)
      redirect_to @study_time
    else
      render 'edit'
    end
  rescue StandardError => e
    redirect_to study_times_path, notice: '勉強時間の更新中にエラーが発生しました'
  end


  def destroy
    @study_time&.destroy
    redirect_to study_times_path, notice: '勉強時間を削除しました'
  end


  private

  def study_time_params
    params.require(:study_time).permit(:started_at, :ended_at, :memo)
  end

  def set_study_time
    @study_time = current_user.study_times.find_by(id: params[:id])
  end
end
