# frozen_string_literal: true

class RegistrationMailer < ApplicationMailer
  default from: "support@wesale.pl"

  def welcome_email
    @email = params[:email]
    mail(to: @email, subject: "Welcome to WeSale")
  end

  def reset_password_email
    @email = params[:email]
    @url = "http://localhost:4000/reset_password?token=#{params[:token]}"
    mail(to: @email, subject: "Password reset")
  end
end
