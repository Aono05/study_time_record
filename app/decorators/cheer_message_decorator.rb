class CheerMessageDecorator < Draper::Decorator
  delegate_all

  def uploaded_image_status
    if image.present?
      "画像あり"
    else
      "画像なし"
    end
  end
end
