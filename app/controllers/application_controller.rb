# frozen_string_literal: true

class ApplicationController < ActionController::API

  before_action :authenticate_user!

  protected

  def authenticate_user!
    user = AuthorizeUser.new(request.headers, request.query_parameters).call
  end

end
