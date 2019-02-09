# frozen_string_literal: true

class TokenUtils
  JWT_SECRET = ENV["JWT_SECRET"]
  class << self
    def encode(payload, exp=24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, JWT_SECRET)
    end

    def decode(token)
      JWT.decode(token, JWT_SECRET)[0]
    rescue JWT::ExpiredSignature, JWT::VerificationError => e
      raise ExceptionHandler::ExpiredSignature, e.message
    rescue JWT::DecodeError, JWT::VerificationError => e
      raise ExceptionHandler::DecodeError, e.message
    end
  end
end
