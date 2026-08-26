module Api
  module V1
    class ItemsController < ApplicationController
      before_action :set_item, only: %i[show update destroy]

      def index
        render json: Item.order(created_at: :desc)
      end

      def show
        render json: @item
      end

      def create
        item = Item.new(item_params)

        if item.save
          render json: item, status: :created
        else
          render json: { errors: item.errors.full_messages }, status: :unprocessable_content
        end
      end

      def update
        if @item.update(item_params)
          render json: @item
        else
          render json: { errors: @item.errors.full_messages }, status: :unprocessable_content
        end
      end

      def destroy
        @item.destroy!
        head :no_content
      end

      private

      def set_item
        @item = Item.find(params[:id])
      end

      def item_params
        params.expect(item: [ :title, :description, :completed ])
      end
    end
  end
end
