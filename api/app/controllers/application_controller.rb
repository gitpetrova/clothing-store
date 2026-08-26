class ApplicationController < ActionController::API
  include Authenticatable
  include CatalogJson

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request

  private

  def not_found
    render json: { error: "Not found" }, status: :not_found
  end

  def bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def render_errors(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_content
  end
end
