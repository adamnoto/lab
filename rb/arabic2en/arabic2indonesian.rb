#!/usr/local/bin/ruby -w
require_relative 'number_sayer'

puts NumberSayer.to_word('id', ARGV[0])
