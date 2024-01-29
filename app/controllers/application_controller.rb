# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonWebToken

  def authenticate_request
    header = request.headers['token']
    header = header.split(' ').last if header
    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:user_id])
  end
end
