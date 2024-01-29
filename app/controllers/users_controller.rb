# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      token = jwt_encode(user_id: user.id)
      render json: {
        message: 'Login successfully',
        token: token,
        user: UserSerializer.new(user).serializable_hash
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
