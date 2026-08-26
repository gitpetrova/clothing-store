module Api
  module V1
    class OrdersController < ApplicationController
      before_action :authenticate_user!

      def index
        orders = current_user.orders.includes(:order_items).order(created_at: :desc)
        render json: orders.map { |order| order_json(order) }
      end

      def show
        render json: order_json(current_user.orders.includes(:order_items).find(params[:id]))
      end

      def create
        order = CreateOrder.call(user: current_user, attributes: order_params)
        render json: order_json(order.reload), status: :created
      rescue CreateOrder::Error => e
        render json: { errors: [ e.message ] }, status: :unprocessable_content
      rescue ActiveRecord::RecordInvalid => e
        render_errors(e.record)
      end

      private

      def order_params
        params.expect(order: [ :email, :customer_name, :shipping_address, items: [ [ :variant_id, :quantity ] ] ])
      end
    end
  end
end
