module Api
  module V1
    module Admin
      class UsersController < BaseController
        before_action :set_user, only: %i[show update]

        def index
          render json: User.order(:email)
        end

        def show
          render json: @user
        end

        def update
          if @user.update(user_params)
            render json: @user
          else
            render_errors(@user)
          end
        end

        private

        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.expect(user: [ :name, :role ])
        end
      end
    end
  end
end
