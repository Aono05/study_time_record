class CheerMessage < ApplicationRecord
  belongs_to :user
  CHEER_MESSAGES = YAML.load_file("config/cheer_messages.yml")
  DEFAULT_IMAGE_NAME = "default.png".freeze
  mount_uploader :image, ImageUploader

  def valid_image
    if image.present?
      image.url
    else
      "/assets/#{DEFAULT_IMAGE_NAME}"
    end
  end

  def uploaded_image_status
    if image.present?
      "画像あり"
    else
      "画像なし"
    end
  end

  class << self
    def random(user)
      if user.cheer_messages.present?
        user.cheer_messages.sample
      else
        random_content
      end
    end

    private
    
    def random_content
      content = CHEER_MESSAGES.sample
      CheerMessage.new(content: content)
    end
  end
end
