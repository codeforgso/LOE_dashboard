class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def js_config
    render json: {
      google_maps_api_key: ENV['GOOGLE_MAPS_API_KEY']
    }
  end
end
