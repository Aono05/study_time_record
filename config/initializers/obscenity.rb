Obscenity.configure do |config|
  config.blacklist   = "config/blacklist.yml"  #ブラックリストへのpath
  config.replacement = :stars       #NGワード置き換え設定
end