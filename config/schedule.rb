# Rails.rootを使用するために環境設定を読み込む
require File.expand_path(File.dirname(__FILE__) + '/environment')

# cronを実行する環境変数をセット
set :environment, ENV['RAILS_ENV'] || :development

# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"

env :PATH, ENV['PATH']

# ジョブを実行するシェルを環境に合わせて変更する
set :job_template, "/bin/zsh -l -c ':job'"
job_type :rake, "export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

# 定期実行したい処理を記載
every :hour do
  rake 'ranking:update_ranking'
end
