# frozen_string_literal: true

class Authentication::AuthenticationController < ApplicationController
  def signin
    user = User.find_by(email: user_params[:email])

    raise ExceptionHandler::AuthenticationError, "You have inserted wrong email" unless user

    if user.authenticate(user_params[:password])
      render json: {token: TokenUtils.encode(id: user.id)}
    else
      raise ExceptionHandler::AuthenticationError, "You have inserted wrong password"
    end
  end

  # fix - check for registration type = nil
  def signup
    user = User.new(user_params)

    if user.save
      RegistrationMailer.with(email: user[:email]).welcome_email.deliver_later
      render json: {token: TokenUtils.encode(id: user[:id])}
    else
      raise ExceptionHandler::AuthenticationError, user.errors.full_messages
    end
  end

  def send_reset_password
    user = User.find_by(email: reset_password_params[:email])

    raise ExceptionHandler::AuthenticationError, "User not found" unless user

    RegistrationMailer.with(email: user[:email], token: TokenUtils.encode({id: user[:id]}, (Time.now.to_i + 3600).to_s))
                      .reset_password_email
                      .deliver_now
  end

  def reset_password
    id = TokenUtils.decode(reset_password_params[:token])["id"]

    user = User.find_by(id: id)

    raise ExceptionHandler::AuthenticationError, "User not found" unless user
    raise ExceptionHandler::AuthenticationError, "Password can't be null" if reset_password_params[:new_password].blank?

    # bcrypt doesnt check if password is null or "" on update
    if user.update(password: reset_password_params[:new_password])
      return render json: {result: "Successfully changed password"}
    else
      raise ExceptionHandler::AuthenticationError, user.errors.full_messages
    end
  end

  private

  def user_params
    params.require(:authentication).permit(:email, :password)
  end

  def reset_password_params
    params.require(:authentication).permit(:email, :token, :new_password)
  end
end
