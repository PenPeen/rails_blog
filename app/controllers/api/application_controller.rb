module Api
  class ApplicationController < ActionController::API
    rescue_from StandardError, with: :render_server_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    private
      def render_server_error(exception)
        logger.error "API Error: #{exception.class.name} - #{exception.message}"
        render json: { error: 'Server error occurred' }, status: :internal_server_error
      end

      def render_not_found(exception)
        logger.info "Not found: #{exception.message}"
        render json: { error: 'Resource not found' }, status: :not_found
      end
  end
end
