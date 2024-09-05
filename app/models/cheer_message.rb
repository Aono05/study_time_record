class CheerMessage < ApplicationRecord
  belongs_to :user
  CHEER_MESSAGES = YAML.load_file("config/cheer_messages.yml")
  DEFAULT_IMAGE_NAME = "default.png".freeze
  mount_uploader :image, ImageUploader

  def valid_image_path
    if image.present?
      image.url
    else
      default_image_path
    end
  end

  def uploaded_image_status
    if image.present?
      "画像あり"
    else
      "画像なし"
    end
  end

  private

  def default_image_path
    ActionController::Base.helpers.image_path(DEFAULT_IMAGE_NAME)
  end

<<<<<<< HEAD
=======

>>>>>>> production
  class << self
    def random(cheer_messages)
      if cheer_messages.present?
        cheer_messages.sample
      else
        random_content
      end
    end

    private

    def random_content
      content = CHEER_MESSAGES.sample
      new(content: content)
    end
  end
end
