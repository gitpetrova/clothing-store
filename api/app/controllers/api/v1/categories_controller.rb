module Api
  module V1
    class CategoriesController < ApplicationController
      def index
        render json: Category.order(:name).map { |category| category_json(category) }
      end

      def show
        render json: category_json(Category.find(params[:id]))
      end
    end
  end
end
