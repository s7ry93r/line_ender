#!/usr/bin/env ruby
require 'rubygems'
require 'line_ender'
require 'test/unit'

class TestLineEnder < Test:: Unit::TestCase

  class TLE
    include LineEnder
  end

  def setup
    puts 'setup'
    @debug = true
    @tle = TLE.new
    @file1 = "file1.txt"
    @file2 = "file2.txt"
  end

  def teardown
    puts 'teardown'
    @tle = nil
    system "rm #{@file1}" if File.exists?(@file1)
    system "rm #{@file2}" if File.exists?(@file2)
  end
  
  def test_mac_to_unix_written_to_new_file
    puts "in test: #{__method__} ..."
    start_value = "a\rb\rc\r"
    fixed_value = "a\nb\nc\n"
    fs = helper_for_file_test(start_value, fixed_value , LineEnder::Ending::Unix, true)
    assert(File.exists?(@file2), "#{__method__} ... has not written to new file")
    assert(fs == fixed_value, "#{__method__} ... fixed file is not a match to expected value") if File.exists?(@file2)
  end

  def test_mac_to_windows_write_to_same_file
    puts "in test: #{__method__} ..."
    start_value = "a\rb\rc\r\r\r"
    fixed_value = "a\r\nb\r\nc\r\n\r\n\r\n"
    fs = helper_for_file_test(start_value, fixed_value , LineEnder::Ending::Windows)
    assert(fs == fixed_value, "#{__method__} ... fixed file is not a match to expected value")
  end

  def test_mac_to_windows_string_dump
    puts "in test: #{__method__} ..."
    start_value = "a\rb\rc\r\r"
    fixed_value = "a\r\nb\r\nc\r\n\r\n"
    helper_write_file(@file1, start_value)
    helper_for_hexdump("start", @file1) if @debug
    fs= @tle.output_to_string(@file1, LineEnder::Ending::Windows)
    assert(fs == fixed_value, "#{__method__} ... fixed file is not a match to expected value")
  end

  def helper_for_file_test(start_value, fixed_value, ending_to_use, new_output_file = false)
    helper_write_file(@file1, start_value)
    helper_for_hexdump("start", @file1) if @debug
    if new_output_file
      @tle.output_to_file( @file1, ending_to_use, @file2 )
      fixed_file = @file2
    else
      @tle.output_to_file( @file1, ending_to_use)
      fixed_file = @file1
    end
    helper_for_hexdump("fixed", fixed_file) if File.exists?(fixed_file) && @debug
    helper_read_file(fixed_file)
  end

  def helper_write_file(file_name, value)
    file = File.new(file_name, "wb")
    file.binmode
    file.write(value)
    file.close
  end

  def helper_read_file(file_name)
    file_string = ""
    if File.exists?(file_name)
      file = File.open(file_name, "rb")
      file.binmode
      file_string = file.read
      puts "contents of file #{file_name} as a string ... #{file_string.inspect}" if @debug
    end
    file_string
  end

  def helper_for_hexdump(which_file, file_name)
    puts "#{which_file} file looks like this ..."
    system "hexdump -C #{file_name}"
  end


end
