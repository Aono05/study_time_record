every :monday, at: '0:00 am' do
  rake "ranking:update_ranking"
end
