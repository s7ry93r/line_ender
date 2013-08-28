#!/usr/bin/env ruby
require 'rubygems'

module LineEnder

 module Ending
   Mac = 1
   Windows = 2
   Unix = 3

   def self.valid?(value)
     return true if value == Ending::Mac || value == Ending::Windows || value == Ending::Unix
     return false
   end
 end

 def initialize
   @debug = false
 end

 def self.included(cls)
   include Ending
 end

 def output_to_file(input_filepath, ending, output_filename='')
   raise RuntimeError, "Something is wrong with the input input filepath!" unless valid_filepath?(input_filepath)
   raise RuntimeError, "Something is wrong with the 'Ending' parameter passed in!" unless valid_ending?(ending)
   output_filepath = get_output_filepath(input_filepath, output_filename)
   puts "output filepath = #{output_filepath}" if @debug

   #this will only happen for an inplace file update
   if (output_filepath == input_filepath)
     raise RuntimeError, "File is not writeable!" unless File.writable?(output_filepath)
   end

   file_as_string = file_to_string(input_filepath)
   fixed_file_string = change_line_endings(file_as_string, ending)
   string_to_file(fixed_file_string, output_filepath)
   return true
 end

 def output_to_string(input_filepath, ending)
   raise RuntimeError, "Something is wrong with the input input filepath!" unless valid_filepath?(input_filepath)
   raise RuntimeError, "Something is wrong with the 'Ending' parameter passed in!" unless valid_ending?(ending)

   file_as_string = file_to_string(input_filepath)
   change_line_endings(file_as_string, ending)
 end

 protected

 def get_output_filepath(input_filepath, output_filename)
   input_path = File.expand_path(input_filepath).split(::File::Separator)
   input_filename = input_path.last
   puts "in get_output_filepath ... input_path = #{input_path}" if @debug
   puts "in get_output_filepath ... input_filename = #{input_filename}" if @debug
   output_filepath = ''
   if output_filename.empty?
     output_filepath = input_filepath
   else
     output_path = output_filename.split(::File::Separator)     
     output_filename = output_path.last
     if output_path.first == output_filename
       if input_filename == output_filename
         output_filepath = input_filepath
       else
         input_path.pop
         output_filepath = File.join(input_path,output_filename)
         puts "in get_output_filepath ... output_filepath = #{output_filepath}" if @debug
       end
     else
       #the output_filename is a path ... lets expand it
       output_path = File.expand_path(output_filename).split(::File::Separator)     
       output_filepath = File.join(output_path)
     end
   end
   output_filepath 
 end

 def string_to_file(fixed_file_string, output_filepath)
     File.delete(output_filepath) if File.exists?(output_filepath)
     File.open(output_filepath, "wb"){|out_file| out_file.write(fixed_file_string)}
 end

 def change_line_endings(file_as_string, ending)
   fixed_file_string = ''
   fixed_file_string = file_as_string.gsub(/(\n)|(\r\n?)/, "\n") if ending == Ending::Unix
   fixed_file_string = file_as_string.gsub(/(\n)|(\r\n?)/, "\r") if ending == Ending::Mac
   fixed_file_string = file_as_string.gsub(/(\n)|(\r\n?)/, "\r\n") if ending == Ending::Windows
   fixed_file_string
 end

 def file_to_string(filepath)
   file = File.open(filepath, "rb")
   file_string = file.read
   file.close
   file_string
 end

 def valid_ending?(ending) 
   raise RuntimeError, "Ending parameter is required!" unless ending
   raise RuntimeError, "Ending parameter must be of type Ending" unless Ending.valid?(ending)
   return true
 end

 def valid_filepath?(filepath)
   raise RuntimeError, "Filepath parameter is required!" unless filepath
   raise RuntimeError, "File with that filepath is not found!" unless File.exists?(filepath)
   raise RuntimeError, "File is not readable!" unless File.readable?(filepath)
   return true
 end


end
