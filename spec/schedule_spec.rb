require 'rails_helper'

describe 'スケジュール' do
  it '毎週月曜日の0時にupdate_rankingタスクがスケジュールされていること' do
    schedule_file = File.expand_path('../../config/schedule.rb', __FILE__)
    schedule_content = File.read(schedule_file)

    expect(schedule_content).to include('every :monday, at: \'0:00 am\' do')
    expect(schedule_content).to include('  rake "ranking:update_ranking"')
  end
end
