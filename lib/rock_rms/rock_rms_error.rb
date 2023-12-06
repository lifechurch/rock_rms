module RockRMS
  class RockRMSError < StandardError
    class BadRequest < RockRMSError; end
    class NotFound < RockRMSError; end
    class NotAllowed < RockRMSError; end
    class TooManyRequests < RockRMSError; end
    class InternalServerError < RockRMSError; end
    class BadGateway < RockRMSError; end
    class ServiceUnavailable < RockRMSError; end
    class GatewayTimeout < RockRMSError; end
    class Error < RockRMSError; end
  end
end

require 'faraday'
module FaradayMiddleware
  class RockRMSErrorHandler < Faraday::Response::Middleware
    ERROR_STATUSES = 400..600

    def on_complete(env)
      case env[:status]
      when 400
        raise RockRMS::RockRMSError::BadRequest.new(error_message(env))
      when 404
        raise RockRMS::RockRMSError::NotFound.new(error_message(env))
      when 405
        raise RockRMS::RockRMSError::NotAllowed.new(error_message(env))
      when 429
        raise RockRMS::RockRMSError::TooManyRequests.new(error_message(env))
      when 500
        raise RockRMS::RockRMSError::InternalServerError.new(error_message(env))
      when 502
        raise RockRMS::RockRMSError::BadGateway.new(error_message(env))
      when 503
        raise RockRMS::RockRMSError::ServiceUnavailable.new(error_message(env))
      when 504
        raise RockRMS::RockRMSError::GatewayTimeout.new(error_message(env))
      when ERROR_STATUSES
        raise RockRMS::RockRMSError::Error.new(error_message(env))
      end
    end

    def error_message(env)
      return "#{env[:status]}: #{env[:body]} #{env[:url]}"
    end
  end
end
