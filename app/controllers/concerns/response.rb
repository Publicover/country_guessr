# frozen_string_literal: true

module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def serialized_response(object)
    serializer = Object.const_get("#{object.class.to_s.slice(/^[^:]*\s*/)}Serializer")
    render status: :ok, json: serializer.new(object).serialized_json
  end
end
