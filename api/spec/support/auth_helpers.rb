module AuthHelpers
  def auth_headers(user)
    { "Authorization" => "Bearer #{JsonWebToken.encode({ sub: user.id, role: user.role })}" }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
