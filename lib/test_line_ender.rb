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
    @debug = false
    @tle = TLE.new
    @file1 = "file1.txt"
    @file2 = "file2.txt"
    @le_mac = "a\\\\rb\\\\rc"
    @le_windows = "a\r\nb\r\nc"
    @le_unix = "a\nb\nc"
    system "echo #{@le_mac} > #{@file1}"
  end

  def teardown
    puts 'teardown'
    @tle = nil
    system "rm #{@file1}" if File.exists?(@file1)
    system "rm #{@file2}" if File.exists?(@file2)
  end
  
  def test_new_file
    puts "from test_new_file ..."
    @tle.output_to_file( @file1, LineEnder::Ending::Unix, @file2 )
    assert(File.exists?(@file2))
    system "hexdump -C #{@file2} | head -n 40" if @debug
    puts "" if @debug
    puts "compare le_unix to #{@le_unix}" if @debug
    fl = File.open(@file2, "rb")
    fs = fl.read
    puts "to file_to_string ... #{fs}" if @debug
    assert(fs == @le_unix)
  end

  def test_inplace_fix
    puts "from test_inplace_fix ..."
    @tle.output_to_file( @file1, LineEnder::Ending::Windows)
    system "hexdump -C #{@file1} | head -n 40" if @debug
    puts "" if @debug
    puts "compare le_windows to #{@le_windows}" if @debug
    fl = File.open(@file1, "rb")
    fs = fl.read
    puts "to file_to_string ... #{fs}" if @debug
    assert(fs == @le_windows)
  end


  def test_string_convert_to_windows
    puts "from test_string_convert_to_windows ..."
    fs= @tle.output_to_string(@file1, LineEnder::Ending::Windows)
    assert(fs == @le_windows)
  end

end
