module Authenticatable
  extend ActiveSupport::Concern

  private

  def authenticate_user!
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end

  def authenticate_admin!
    authenticate_user!
    return if performed?

    render json: { error: "Forbidden" }, status: :forbidden unless current_user.admin?
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = find_user_from_token
  end

  def find_user_from_token
    token = bearer_token
    return if token.blank?

    payload = JsonWebToken.decode(token)
    User.find_by(id: payload["sub"])
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  def bearer_token
    header = request.headers["Authorization"].to_s
    scheme, token = header.split(" ", 2)
    token if scheme&.casecmp("bearer")&.zero?
  end
end
