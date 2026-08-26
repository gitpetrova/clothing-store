module Api
  module V1
    module Admin
      class ProductsController < BaseController
        before_action :set_product, only: %i[show update destroy]

        def index
          products = Product.includes(:category, :variants, :product_images).order(:name)
          render json: products.map { |product| product_json(product) }
        end

        def show
          render json: product_json(@product)
        end

        def create
          product = Product.new(product_params)

          if product.save
            render json: product_json(product), status: :created
          else
            render_errors(product)
          end
        end

        def update
          if @product.update(product_params)
            render json: product_json(@product)
          else
            render_errors(@product)
          end
        end

        def destroy
          if @product.destroy
            head :no_content
          else
            render_errors(@product)
          end
        end

        private

        def set_product
          @product = Product.includes(:category, :variants, :product_images).find(params[:id])
        end

        def product_params
          params.expect(product: [ :name, :slug, :description, :category_id ])
        end
      end
    end
  end
end
