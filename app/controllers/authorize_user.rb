class AuthorizeUser
  def initialize(headers = {}, params = {})
    @headers = headers
    @params = params
  end

  def call
    user
  end

  private

  attr_reader :headers, :params

  def user
    @user ||= User.find(decoded_token["id"]) if decoded_token
  rescue ActiveRecord::RecordNotFound => e
    raise ExceptionHandler::InvalidToken "Token is invalid"
  end

  def decoded_token
    @decoded_token = TokenUtils.decode(token_data)
  end

  def token_data
    return headers['Bearer'].split(' ').last if headers.key?('Bearer')

    return params['authentication']['token'] if params['authentication'].key?('token')
      
    raise ExceptionHandler::AuthenticationError, "Token non found" 
  end

end
