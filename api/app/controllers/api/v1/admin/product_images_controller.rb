module Api
  module V1
    module Admin
      class ProductImagesController < BaseController
        before_action :set_product, only: %i[index create]
        before_action :set_product_image, only: %i[show update destroy]

        def index
          render json: @product.product_images.order(:position).map { |image| product_image_json(image) }
        end

        def show
          render json: product_image_json(@product_image)
        end

        def create
          image = @product.product_images.new(product_image_params)

          if image.save
            render json: product_image_json(image), status: :created
          else
            render_errors(image)
          end
        end

        def update
          if @product_image.update(product_image_params)
            render json: product_image_json(@product_image)
          else
            render_errors(@product_image)
          end
        end

        def destroy
          @product_image.destroy!
          head :no_content
        end

        private

        def set_product
          @product = Product.find(params[:product_id])
        end

        def set_product_image
          @product_image = ProductImage.find(params[:id])
        end

        def product_image_params
          params.expect(product_image: [ :url, :alt_text, :position, :variant_id ])
        end
      end
    end
  end
end
