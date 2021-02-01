class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  
  def routing_error
    e_message = "No route #{request.original_fullpath} for a #{request.request_method} request."
    json_response({ message: e_message }, :not_found)
  end
end
