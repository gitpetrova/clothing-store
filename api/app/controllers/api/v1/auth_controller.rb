module Api
  module V1
    class AuthController < ApplicationController
      def register
        user = User.new(register_params.merge(role: :user))

        if user.save
          render json: auth_payload(user), status: :created
        else
          render_errors(user)
        end
      end

      def login
        user = User.find_by(email: params[:email].to_s)

        if user&.authenticate(params[:password].to_s)
          render json: auth_payload(user)
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      private

      def register_params
        params.expect(user: [ :name, :email, :password, :password_confirmation ])
      end

      def auth_payload(user)
        { token: JsonWebToken.encode({ sub: user.id, role: user.role }), user: user }
      end
    end
  end
end
