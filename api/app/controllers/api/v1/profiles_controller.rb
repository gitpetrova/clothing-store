module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_user!

      def show
        render json: current_user
      end

      def update
        if current_user.update(profile_params)
          render json: current_user
        else
          render_errors(current_user)
        end
      end

      private

      def profile_params
        params.expect(user: [ :name, :password, :password_confirmation ])
      end
    end
  end
end
