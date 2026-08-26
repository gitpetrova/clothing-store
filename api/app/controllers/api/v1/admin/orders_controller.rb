module Api
  module V1
    module Admin
      class OrdersController < BaseController
        before_action :set_order, only: %i[show update]

        def index
          orders = Order.includes(:order_items, :user).order(created_at: :desc)
          render json: orders.map { |order| order_json(order) }
        end

        def show
          render json: order_json(@order)
        end

        def update
          if @order.update(order_params)
            render json: order_json(@order)
          else
            render_errors(@order)
          end
        end

        private

        def set_order
          @order = Order.includes(:order_items).find(params[:id])
        end

        def order_params
          params.expect(order: [ :status ])
        end
      end
    end
  end
end
