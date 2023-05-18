class CheerMessage < ApplicationRecord
  CHEER_MESSAGES = YAML.load_file("config/cheer_messages.yml")

  class << self
    def random_content
      CHEER_MESSAGES.sample
    end
  end
end
