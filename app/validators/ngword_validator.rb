class NgwordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, text)
    return if text.blank?
    return unless ng_word_regexp.match?(text)

    record.errors.add(attribute, 'にNGワードが含まれています。')
  end

  private

  def ng_word_regexp
    @ng_word_regexp ||= Regexp.new(ng_pattern)
  end

  def ng_pattern
    yaml_file_path = Rails.root.join('config/blacklist.yml')
    YAML.load_file(yaml_file_path).join('|')
  end
end
