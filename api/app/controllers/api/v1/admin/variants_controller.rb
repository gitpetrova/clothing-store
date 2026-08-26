module Api
  module V1
    module Admin
      class VariantsController < BaseController
        before_action :set_product, only: %i[index create]
        before_action :set_variant, only: %i[show update destroy]

        def index
          render json: @product.variants.order(:size, :color).map { |variant| variant_json(variant) }
        end

        def show
          render json: variant_json(@variant)
        end

        def create
          variant = @product.variants.new(variant_params)

          if variant.save
            render json: variant_json(variant), status: :created
          else
            render_errors(variant)
          end
        end

        def update
          if @variant.update(variant_params)
            render json: variant_json(@variant)
          else
            render_errors(@variant)
          end
        end

        def destroy
          if @variant.destroy
            head :no_content
          else
            render_errors(@variant)
          end
        end

        private

        def set_product
          @product = Product.find(params[:product_id])
        end

        def set_variant
          @variant = Variant.find(params[:id])
        end

        def variant_params
          params.expect(variant: [ :sku, :size, :color, :price, :stock ])
        end
      end
    end
  end
end
