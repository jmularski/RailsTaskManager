class Leader::AuthenticationController < ApplicationController

  def signin
    user = Leader.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      render json: {token: TokenUtils.encode(id: user.id)}
    else
      render json: {error: user.errors.full_messages, result: 'failure'}, status: 401
    end
  end

  def signup
    user = Leader.new(user_params)
    if user.save
      render json: {token: TokenUtils.encode(id: user.id), result: 'success'}
    else
      render json: {error: user.errors.full_messages, result: 'failure'}, status: 401
    end
  end

  private

  def user_params
    params.require(:authentication).permit(:email, :password)
  end

end