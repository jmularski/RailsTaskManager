# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end
  class DecodeError < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken,        with: :unprocessable_entity
    rescue_from ExceptionHandler::InvalidToken,        with: :unprocessable_entity
    rescue_from ExceptionHandler::ExpiredToken,        with: :unauthorized_token
    rescue_from ExceptionHandler::DecodeToken,         with: :unauthorized_token
  end

  private

  def unprocessable_entity(err)
    render json: {error: err.message}, status: :unprocessable_entity
  end

  def unauthorized_token(err)
    render json: {error: err.message}, status: :invalid_token
  end

  def unauthorized_request(err)
    render json: {error: err}, status: :unauthorized
  end
end
