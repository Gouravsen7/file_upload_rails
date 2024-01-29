class UsersController < ApplicationController
  before_action :authorize_request
  
  def create
    email = params[:email].downcase
    user = User.find_by(email: email, password: params[:password])
    if user.present?
      render json: {
        message: "Login successfully",
        user: UserSerializer.new(user).serializable_hash
      }, status: :ok
    else
      render json: { message: "Invalid Crendentials" }, status: :unauthorized
    end
  end
end
