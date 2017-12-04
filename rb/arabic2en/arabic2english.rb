#!/usr/local/bin/ruby -w
require_relative 'number_sayer'

puts NumberSayer.to_word('en', ARGV[0])
