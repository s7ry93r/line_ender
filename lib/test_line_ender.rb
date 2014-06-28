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
    puts "---> in test: #{__method__} ..."
    start_value = ["a", "b", "c"].join("\r")
    expected_value = ["a", "b", "c"].join("\n")

    helper_print_start_values(start_value, expected_value)
    output_string = helper_for_file_test(start_value, expected_value , LineEnder::Ending::Unix, true)
    helper_print_output_value(output_string)

    assert(File.exists?(@file2), "#{__method__} ... has not written to new file")
    assert(output_string == expected_value, "#{__method__} ... output string is not a match to expected value") if File.exists?(@file2)
  end

  def test_mac_to_windows_write_to_same_file
    puts "---> in test: #{__method__} ..."
    start_value = ["a", "b", "c"].join("\r")
    expected_value = ["a", "b", "c"].join("\r\n")

    helper_print_start_values(start_value, expected_value)
    output_string = helper_for_file_test(start_value, expected_value , LineEnder::Ending::Windows)
    helper_print_output_value(output_string)

    assert(output_string == expected_value, "#{__method__} ... output string is not a match to expected value")
  end

  def test_mac_to_windows_string_dump
    puts "---> in test: #{__method__} ..."
    start_value = ["a", "b", "c"].join("\r")
    expected_value = ["a", "b", "c"].join("\r\n")

    helper_print_start_values(start_value, expected_value)
    helper_write_file(@file1, start_value)
    helper_for_hexdump("start", @file1)
    output_string= @tle.output_to_string(@file1, LineEnder::Ending::Windows)
    helper_print_output_value(output_string)

    assert(output_string == expected_value, "#{__method__} ... output string is not a match to expected value")

  end

  def helper_print_start_values(start_value, expected_value)
    puts("start value ... getting pushed into file1.txt: #{start_value.inspect}")
    puts("expected value: #{expected_value.inspect}")
  end

  def helper_print_output_value(output_value)
    puts("output value (as string): #{output_value.inspect}")
  end

  def helper_for_file_test(start_value, expected_value, ending_to_use, new_output_file = false)
    helper_write_file(@file1, start_value)
    helper_for_hexdump("start", @file1) 
    if new_output_file
      @tle.output_to_file( @file1, ending_to_use, @file2 )
      output_file = @file2
    else
      @tle.output_to_file( @file1, ending_to_use)
      output_file = @file1
    end
    helper_for_hexdump("output", output_file) if File.exists?(output_file)
    helper_read_file(output_file) if File.exists?(output_file)
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
      #puts "contents of file #{file_name} as a string ... #{file_string.inspect}" 
    end
    file_string
  end

  def helper_for_hexdump(which_file, file_name)
    puts "#{which_file} file looks like this ..."
    system "hexdump -C #{file_name}"
  end


end
