class ErrorsController < ActionController::Base
  def not_found
    render text: "404 Not found", status: 404
  end

  def exception
    render text: "500 Internal Server Error", status: 500
  end
end