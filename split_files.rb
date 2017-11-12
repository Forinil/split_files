#!/usr/bin/env ruby

require 'English'
require_relative 'custom_logger'
require_relative 'directory_processor'

def set_size(size_string)
  # default is 10 MB
  return 10485760 if size_string.nil?

  size = size_string.dup
  if size =~ /MB$/
    size.sub!(/MB$/, '')
    return Integer(size)*1024**2
  elsif size =~ /KB$/
    size.sub!(/KB$/, '')
    return Integer(size)*1024
  elsif size =~/B$/
    size.sub!(/B$/, '')
  end
  Integer(size)
end

begin
  logger = nil
  if ARGV.length >= 1
    dir = ARGV[0]
    max_size = set_size(ARGV[1])
    logger = CustomLogger.new($PROGRAM_NAME, ARGV[2])
    result_path = ARGV[3]

    if result_path.nil?
      DirectoryProcessor.process_dir(logger, dir, max_size)
    else
      DirectoryProcessor.process_dir(logger, dir, max_size, result_path)
    end
  else
    puts "Usage:\n ./#{File.basename($PROGRAM_NAME)} "\
      'directory_path max_size(optional) log_dir(optional) result_path(optional)'
  end
rescue => err
  message = "Error: #{err} from #{$ERROR_POSITION}"
  if logger.nil?
    puts(message)
  else
    logger.log(Logger::FATAL) { message }
  end
end