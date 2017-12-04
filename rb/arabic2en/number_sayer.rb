require 'yaml'

module NumberSayer
  extend self

  @@locales = {}

  def get_locale(locale)
    return @@locales[locale] if @@locales[locale]
    loc_data = YAML.load_file("locale/#{locale}.yml")
    fail ArgumentError, "Unknown locale" unless loc_data['number_sayer']
    @@locales[locale] = loc_data['number_sayer']
  end

  def to_word(locale, number_str)
    number = number_str.to_s.gsub(/[^0-9-]/, '').to_i
    humanized_number = humanize(locale, magnitudify(locale, number.abs))
    minus_text = get_locale(locale)['minus']
    number < 0 ? "#{minus_text} #{humanized_number}" : humanized_number
  end

  def magnitudify(locale_name, number)
    power_data = get_locale(locale_name)['power']
    num_mags = []
    remainder = number

    power_data.keys[0...number.abs.digits.count].reverse.each do |zeroes|
      power_ten = 10 ** zeroes
      current_number = remainder / power_ten
      next if current_number == 0 # useless when stand on its own
      num_mags << [current_number, zeroes]
      remainder %= power_ten
    end # each

    num_mags
  end

  def demagnitudify(data)
    number = 0
    data.each do |real_number, zeroes|
      number += (real_number * (10 ** zeroes))
    end
    number
  end

  def humanize(locale_name, data)
    locale = get_locale(locale_name)
    text_numerals = locale['numerals']
    text_powers = locale['power']
    worded = text_numerals[demagnitudify(data)] || ""
    return worded unless worded.empty?

    data_head = data[0]
    data_tail = data[1..-1]

    data_head.each_slice(2) do |real_number, zeroes|
      real_number_with_magnitude = real_number * (10 ** zeroes)
      real_number_text = text_numerals[real_number]
      zeroes_text = text_powers[zeroes]
      current_number_text = text_numerals[real_number_with_magnitude]

      unless current_number_text
        if real_number > 9
          current_number_text = humanize(locale_name, magnitudify(locale_name, real_number))
          current_number_text = "#{current_number_text}#{zeroes_text}"
        else
          current_number_text = "#{real_number_text}#{zeroes_text}"
        end        
      end

      current_number_text = data_tail.any? ?
        parse_formatter(locale['formatter'], zeroes, current_number_text) :
        current_number_text
      worded << current_number_text
      worded << " "
      worded << humanize(locale_name, data_tail) if data_tail.any?
    end
    worded.strip
  end

  def parse_formatter(all_formatter, zeroes, text)
    if all_formatter
      formatter = all_formatter[zeroes]
      if formatter
        before, after = formatter['before'], formatter['after']
        text = "#{before} #{text}" if before
        text = "#{text} #{after}" if after
      end
    end

    text
  end
end
