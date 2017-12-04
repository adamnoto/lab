#!/usr/local/bin/ruby -w
require_relative 'number_sayer'

puts NumberSayer.to_word('jp', ARGV[0])
