module ExceptionHandler

  extend ActiveSupport::Concern

  class CustomValidationError < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end
    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end
    rescue_from ExceptionHandler::CustomValidationError do |e|
      json_response({ message: e.message }, :not_acceptable)
    end
    rescue_from ArgumentError do |e|
      json_response({ message: e.message }, :internal_server_error)
    end
  end

end