class NgwordValidator < ActiveModel::EachValidator
  NGWORD_REGEX = /(.)\1{4,}/.freeze

  def validate_each(record, attribute, value)
    return value.blank?

    if value.match?(NGWORD_REGEX)
      record.errors.add(attribute, 'に5文字以上の繰り返し文字が含まれています。')
    end

    if Obscenity.profane?(value)
      record.errors.add(attribute, 'にNGワードが含まれています。')
    end
  end
end
