require 'English'
require_relative 'custom_logger'
require_relative 'file_processor'

# Class DirectoryProcessor - processes a single directory and its subdirectories
class DirectoryProcessor
  private_class_method def self.process_file(logger, dir, file_name, max_size, result_path)
    path = "#{dir}\\#{file_name}"
    logger.log(Logger::DEBUG, "Processing path: #{path}", 'DirectoryProcessor.process_file')
    if !File.directory?(path)
      logger.log(Logger::DEBUG, "Found file: #{file_name}", 'DirectoryProcessor.process_file')
      FileProcessor.process_file(logger, path, max_size, result_path)
    else
      logger.log(Logger::DEBUG, "Found directory: #{file_name}", 'DirectoryProcessor.process_file')
      if !file_name.eql?('.') && !file_name.eql?('..')
        process_dir(logger, path, max_size, result_path)
      end
    end
  end

  def self.process_dir(logger, dir = (ENV['TEMP']).to_s, max_size = 10485760, result_path = dir)
    logger.log(Logger::INFO, "Opening directory: #{dir}", 'DirectoryProcessor.process_dir')
    files = Dir.entries(dir)

    files.each do |file_name|
      process_file(logger, dir, file_name, max_size, result_path)
    end
  end
end