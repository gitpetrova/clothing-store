module Api
  module V1
    class VariantsController < ApplicationController
      before_action :authenticate_user!

      def index
        product = Product.includes(:variants).find(params[:product_id])
        render json: product.variants.order(:size, :color).map { |variant| variant_json(variant) }
      end

      def show
        render json: variant_json(Variant.find(params[:id]))
      end
    end
  end
end
