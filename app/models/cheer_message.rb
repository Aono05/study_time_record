class CheerMessage < ApplicationRecord
  belongs_to :user
  CHEER_MESSAGES = YAML.load_file("config/cheer_messages.yml")
  mount_uploader :image, ImageUploader

  class << self
    def user_random_content(user)
      if user.cheer_messages.present?
        @random_cheer_message = user.cheer_messages.sample.content
      else
        @random_cheer_message = random_content
      end
    end

    def random_content
      CHEER_MESSAGES.sample
    end
  end
end
