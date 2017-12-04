require 'spec_helper'

describe NumberSayer do
  subject { described_class }
  let(:locale) { 'en' }
  
  describe '#to_word' do
    it 'converts basic numerals' do
      expect(subject.to_word(locale, 0)).to eq 'zero'
      expect(subject.to_word(locale, 1)).to eq 'one'
      expect(subject.to_word(locale, 2)).to eq 'two'
      expect(subject.to_word(locale, 3)).to eq 'three'
      expect(subject.to_word(locale, 4)).to eq 'four'
      expect(subject.to_word(locale, 5)).to eq 'five'
      expect(subject.to_word(locale, 6)).to eq 'six'
      expect(subject.to_word(locale, 7)).to eq 'seven'
      expect(subject.to_word(locale, 8)).to eq 'eight'
      expect(subject.to_word(locale, 9)).to eq 'nine'
      expect(subject.to_word(locale, 10)).to eq 'ten'
    end

    it 'converts number in the magnitude of 10^1' do
      expect(subject.to_word(locale, 11)).to eq 'eleven'
      expect(subject.to_word(locale, 12)).to eq 'twelve'
      expect(subject.to_word(locale, 13)).to eq 'thirteen'
      expect(subject.to_word(locale, 14)).to eq 'fourteen'
      expect(subject.to_word(locale, 15)).to eq 'fifteen'
      expect(subject.to_word(locale, 16)).to eq 'sixteen'
      expect(subject.to_word(locale, 17)).to eq 'seventeen'
      expect(subject.to_word(locale, 18)).to eq 'eighteen'
      expect(subject.to_word(locale, 19)).to eq 'nineteen'
      expect(subject.to_word(locale, 20)).to eq 'twenty'
      expect(subject.to_word(locale, 23)).to eq 'twenty three'
      expect(subject.to_word(locale, 28)).to eq 'twenty eight'
      expect(subject.to_word(locale, 38)).to eq 'thirty eight'
      expect(subject.to_word(locale, 49)).to eq 'fourty nine'
      expect(subject.to_word(locale, 59)).to eq 'fifty nine'
      expect(subject.to_word(locale, 62)).to eq 'sixty two'
      expect(subject.to_word(locale, 71)).to eq 'seventy one'
      expect(subject.to_word(locale, 87)).to eq 'eighty seven'
      expect(subject.to_word(locale, 99)).to eq 'ninety nine'            
    end

    it 'converts higher magnitudes numbers with proper -and-' do
      expect(subject.to_word(locale, 100)).to eq 'one hundred'
      expect(subject.to_word(locale, 101)).to eq 'one hundred and one'
      expect(subject.to_word(locale, 1000)).to eq 'one thousand'
      expect(subject.to_word(locale, 1001)).to eq 'one thousand one'
      expect(subject.to_word(locale, 1011)).to eq 'one thousand eleven'
      expect(subject.to_word(locale, 1100)).to eq 'one thousand one hundred'
      expect(subject.to_word(locale, 1101)).to eq 'one thousand one hundred and one'
      expect(subject.to_word(locale, 1111)).to eq 'one thousand one hundred and eleven'
      expect(subject.to_word(locale, 999999)).to eq 'nine hundred and ninety nine thousand nine hundred and ninety nine'
    end

    it 'handles minus' do
      expect(subject.to_word(locale, -1)).to eq 'negative one'
      expect(subject.to_word(locale, -100)).to eq 'negative one hundred'
    end

    it 'handles huge number' do
      expect(subject.to_word(locale, 11_111)).to eq 'eleven thousand one hundred and eleven'
      expect(subject.to_word(locale, 111_111)).to eq 'one hundred and eleven thousand one hundred and eleven'
      expect(subject.to_word(locale, 1_111_111)).to eq 'one million one hundred and eleven thousand one hundred and eleven'
      expect(subject.to_word(locale, 11_111_111)).to eq 'eleven million one hundred and eleven thousand one hundred and eleven'
      expect(subject.to_word(locale, 928329388729346293742342394723947239472394832462984723984729)).to eq 'nine hundred and twenty eight octodecillion three hundred and twenty nine septendecillion three hundred and eighty eight sexdecillion seven hundred and twenty nine quindecillion three hundred and fourty six quattuordecillion two hundred and ninety three tredecillion seven hundred and fourty two duodecillion three hundred and fourty two undecillion three hundred and ninety four decillion seven hundred and twenty three nonillion nine hundred and fourty seven octillion two hundred and thirty nine septillion four hundred and seventy two sextillion three hundred and ninety four quintillion eight hundred and thirty two quadrillion four hundred and sixty two trillion nine hundred and eighty four billion seven hundred and twenty three million nine hundred and eighty four thousand seven hundred and twenty nine'
    end

    it 'can process badly formatted number' do
      expect(subject.to_word(locale, ' 111  111')).to eq 'one hundred and eleven thousand one hundred and eleven'
      expect(subject.to_word(locale, '2 4   9')).to eq 'two hundred and fourty nine'
    end
  end

  describe '#magnitudify' do
    it 'groups number by magnitudes' do
      expect(subject.magnitudify(locale, 2000)).to eq [[2, 3]]
      expect(subject.magnitudify(locale, 2492)).to eq [[2, 3], [4, 2], [9, 1], [2, 0]]
    end
  end

  describe '#demagnitudify' do
    it 'converts the data structure to proper number' do
      expect(subject.demagnitudify([[2, 3]])).to eq 2000
      expect(subject.demagnitudify([[2, 3], [4, 2], [9, 1], [2, 0]])).to eq 2492
    end
  end

  describe '#parse_formatter' do
    it 'could prepend a before text' do
      formatter = {2 => {'before' => 'and'}}
      expect(subject.parse_formatter(formatter, 2, 'one hundred')).to eq 'and one hundred'
    end

    it 'could append an after text' do
      formatter = {2 => {'after' => 'and'}}
      expect(subject.parse_formatter(formatter, 2, 'one hundred')).to eq 'one hundred and'
    end
  end
end
