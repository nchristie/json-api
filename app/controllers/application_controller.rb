class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :ensure_user

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { "error" => {"message"=>"#{exception}"} }, status: 404
  end

  private

  def ensure_user
    unless user
      render nothing: true, status: :unauthorized
      false
    end
  end

  def user
    authenticate_or_request_with_http_token do |token, options|
      @user = User.find_by(access_token: token)
    end
  end
end
