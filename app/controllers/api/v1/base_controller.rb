class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    api_error(status: 404, errors: 'Not found')
  end

  def api_error(status: 500, errors: [])
    return head status: status if errors.empty?

    render json: errors.to_json, status: status
  end
end
