# frozen_string_literal: true

class Authentication::AuthenticationController < ApplicationController
  def signin
    user = User.find_by(email: user_params[:email])

    return render json: {error: "You have inserted wrong email"}, status: :unauthorized unless user

    if user.authenticate(user_params[:password])
      render json: {token: TokenUtils.encode(id: user.id)}
    else
      render json: {error: "You have inserted wrong password"}, status: :unauthorized
    end
  end

  # fix - check for registration type = nil
  def signup
    user = User.new(user_params)

    if user.save
      RegistrationMailer.with(email: user[:email]).welcome_email.deliver_later
      render json: {token: TokenUtils.encode(id: user[:id])}
    else
      render json: {error: user.errors.full_messages}, status: :unauthorized unless user.save
    end
  end

  def send_reset_password
    user = User.find_by(email: user_params[:email])

    return render json: {error: "User not found"}, status: :unauthorized unless user

    RegistrationMailer.with(email: user[:email], token: TokenUtils.encode(id: user[:id]))
                      .reset_password_email
                      .deliver_now
  end

  private

  def user_params
    params.require(:authentication).permit(:email, :password)
  end
end
