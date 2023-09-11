class NgwordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    return unless ng_word_regex.match?(value)

    record.errors.add(attribute, 'にNGワードが含まれています。')
  end

  private

  def ng_word_regex
    @ng_word_regex ||= create_ng_word_regex
  end

  def create_ng_word_regex
    yaml_file_path = Rails.root.join('config/blacklist.yml')
    ng_words = YAML.load_file(yaml_file_path)
    ng_pattern = ng_words.join('|')
    Regexp.new(ng_pattern)
  end
end
