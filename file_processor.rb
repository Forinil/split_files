require 'English'
require_relative 'custom_logger'

# Class FileProcessor - processes a single file
class FileProcessor
  def self.process_file(logger, path, max_size, result_path)
    logger.log(Logger::INFO,
               "Processing file: #{path}, maximum size: #{max_size} B",
               'FileProcessor.process_file')


    File.open(path, 'r') do |in_file|
      process_file_internal(logger, path, in_file, result_path, max_size)
    end
  end

  private_class_method
  def self.open_new_file(logger, out_file, out_file_name)
    if out_file.nil? || out_file.closed?
      logger.log(Logger::DEBUG, "Creating output file: #{out_file_name}",
                 'FileProcessor.open_new_file')
      return File.open(out_file_name, 'w')
    end
    out_file
  end

  private_class_method
  def self.compute_out_file_name(logger, path, file_num, result_path)
    message = "Path: #{path}, file number: #{file_num}, output directory: #{result_path}"
    logger.log(Logger::DEBUG,
               message,
               'FileProcessor.compute_out_file_name')
    suffix = File.extname(path)
    prefix = File.basename(path, '.*')
    result_path + File::SEPARATOR + prefix + ".#{file_num.to_s.rjust(4, '0')}" + suffix
  end

  private_class_method
  def self.process_file_internal(logger, path, in_file, result_path, max_size)
    file_num = 0
    bytes = 0
    out_file_name = compute_out_file_name(logger, path, file_num, result_path)
    out_file = open_new_file(logger, nil, out_file_name)

    processing_loop_args = [bytes, file_num, in_file, logger, max_size,
                            out_file, path, result_path]

    out_file = processing_loop(processing_loop_args)

    out_file.close unless out_file.nil? || out_file.closed?
  end

  private_class_method
  def self.processing_loop(processing_loop_args)
    bytes, file_num, in_file, logger,
        max_size, out_file, path, result_path = processing_loop_args
    in_file.each_line do |line|
      out_file = open_new_file(logger, out_file,
                               compute_out_file_name(logger,
                                                     path,
                                                     file_num,
                                                     result_path))
      out_file.puts line
      bytes += line.length
      next unless bytes > max_size
      bytes = 0 && file_num += 1 && out_file.close
    end
    out_file
  end
end