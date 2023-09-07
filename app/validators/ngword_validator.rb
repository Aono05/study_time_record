class NgwordValidator < ActiveModel::EachValidator
  NGWORD_REGEX = /(.)\1{4,}/.freeze

  def validate_each(record, attribute, value)
    if value.present? && (value.match?(NGWORD_REGEX) || Obscenity.profane?(value))
      record.errors.add(attribute, 'に5文字以上の繰り返し文字またはNGワードが含まれています。')
    end
  end
end
