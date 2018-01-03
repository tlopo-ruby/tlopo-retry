require "tlopo/retry/version"
require 'logger'
require 'timeout'

module Tlopo
  LOGGER ||= proc do 
    logger = Logger.new(ENV['TLOPO_LOG_LEVEL'] ? STDERR : '/dev/null')
    logger.level = ENV['TLOPO_LOG_LEVEL'] ? "#{ENV['TLOPO_LOG_LEVEL'].upcase}" :  Logger::ERROR
    logger
  end.call
  
end

module Tlopo::Retry 
  LOGGER = Tlopo::LOGGER
  LOGGER.debug "#{self} loaded"
  def self.retry(opts={},&block)
    is_fork = opts[:fork]
    return local(opts,&block) unless is_fork
    return child(opts,&block) if is_fork
  end

  private 
  def self.child(opts={},&block)
    read, write = IO.pipe
  
    pid = fork do
      read.close
      begin 
        result = local(opts,&block)
        Marshal.dump({result: result, error: nil}, write)
      rescue => e
        Marshal.dump({result:nil, error: e},write)
      end
    end
  
    write.close
    result = Marshal.load(read.read)
    Process.wait(pid)
    raise result[:error] if result[:error]
    result[:result]
  end

  def self.local(opts={},&block)
    tries = opts[:tries] || 3
    timeout = opts[:timeout] || 0
    interval = opts[:interval] || 1
    desc = opts[:desc]
    cleanup = opts[:cleanup] 
    LOGGER.debug "opts: #{opts}"
    LOGGER.debug "tries: #{tries}"
    count = 0
    begin
      count += 1
      Timeout::timeout(timeout) { yield }
    rescue => e 
      unless count > tries 
        msg = "#{self} Retrying to #{desc} #{count} out of #{tries}"
        LOGGER.info msg if desc
        LOGGER.debug "#{self} Calling cleanup" if cleanup
        cleanup.call if cleanup
        sleep interval
        retry 
      else
        raise e
      end
    end
  end
end

