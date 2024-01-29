# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonWebToken

  def authenticate_request
    begin
      header = request.headers['token']
      header = header.split(' ').last if header
      decoded = jwt_decode(header)
      if decoded.nil?
        render json: { error: 'Invalid or expired token' }, status: :unauthorized
        return
      else
        @current_user = User.find(decoded[:user_id])
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end
end
