# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :authorize_request
  attr_reader :current_user

  def serialized_response(object, status = :ok)
    serializer = Object.const_get("#{object.class.to_s.slice(/^[^:]*\s*/)}Serializer")
    render status: status, json: serializer.new(object).serializable_hash.to_json
  end

  private

    def authorize_request
      @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
    end
end
