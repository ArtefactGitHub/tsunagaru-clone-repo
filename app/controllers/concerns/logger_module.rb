module LoggerModule
  extend ActiveSupport::Concern

  included do
    def log_debug(message)
      logger.debug '=========================='
      logger.debug '[log_debug]'
      logger.debug message
      logger.debug '=========================='
    end

    def log_warning(message)
      logger.warn '=========================='
      logger.warn '[log_warning]'
      logger.warn message
      logger.warn '=========================='
    end
  end
end
