class NgwordValidator < ActiveModel::EachValidator
  NGWORD_REGEX = /(.)\1{4,}/.freeze

  def validate_each(record, attribute, value)
    if value.present? && value.match?(NGWORD_REGEX)
      record.errors.add(attribute, 'は5文字以上の繰り返しは禁止です')
    end
  end
end
