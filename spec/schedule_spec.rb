require 'rails_helper'

describe 'スケジュール' do
  it '1時間ごとにupdate_rankingタスクがスケジュールされていること' do
    schedule_file = File.expand_path('../../config/schedule.rb', __FILE__)
    schedule_content = File.read(schedule_file)

    expect(schedule_content).to include('every :hour do')
    expect(schedule_content).to include('  rake "ranking:update_ranking"')
  end
end
