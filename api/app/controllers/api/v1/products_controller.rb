module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_product, only: :show

      def index
        products = Product.includes(:category, :variants, :product_images).order(:name)
        products = products.where(category_id: params[:category_id]) if params[:category_id].present?

        render json: products.map { |product| product_json(product) }
      end

      def show
        render json: product_json(@product)
      end

      private

      def set_product
        @product = Product.includes(:category, :variants, :product_images).find(params[:id])
      end
    end
  end
end
