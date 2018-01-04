require 'tlopo/retry/version'
require 'logger'
require 'timeout'

module Tlopo
  LOGGER ||= proc do
    logger = Logger.new(ENV['TLOPO_LOG_LEVEL'] ? STDERR : '/dev/null')
    logger.level = ENV['TLOPO_LOG_LEVEL'] ? ENV['TLOPO_LOG_LEVEL'].upcase.to_s : Logger::ERROR
    logger
  end.call
end

module Tlopo::Retry
  LOGGER = Tlopo::LOGGER
  LOGGER.debug("#{self} loaded")
  VALID_OPTS = [ :tries, :timeout, :interval, :fork, :cleanup]

  def self.validate_opts(opts)
    opts.keys.each do |k|
      msg = "Option #{k} is invalid. Valid options: #{VALID_OPTS}"
      raise RuntimeError.new msg unless VALID_OPTS.include? k
    end
  end 

  def self.retry(opts = {}, &block)
    validate_opts opts
    is_fork = opts[:fork]
    return local(opts, &block) unless is_fork
    return child(opts, &block) if is_fork
  end

  def self.child(opts = {}, &block)
    read, write = IO.pipe

    pid = fork do
      read.close
      begin
        result = local(opts, &block)
        Marshal.dump({ result: result, error: nil }, write)
      rescue StandardError => e
        Marshal.dump({ result: nil, error: e }, write)
      end
    end

    write.close
    result = Marshal.load(read.read)
    Process.wait(pid)
    raise result[:error] if result[:error]
    result[:result]
  end

  def self.local(opts = {})
    tries = opts[:tries] || 3
    timeout = opts[:timeout] || 0
    interval = opts[:interval] || 1
    desc = opts[:desc]
    cleanup = opts[:cleanup]
    LOGGER.debug("opts: #{opts}")
    LOGGER.debug("tries: #{tries}")
    count = 0
    begin
      count += 1
      Timeout.timeout(timeout) { yield }
    rescue StandardError => e
      if count > tries
        raise e
      else
        msg = "#{self} Retrying to #{desc} #{count} out of #{tries}"
        LOGGER.info(msg) if desc
        LOGGER.debug("#{self} Calling cleanup") if cleanup
        cleanup.call if cleanup
        sleep(interval)
        retry
      end
    end
  end
end
