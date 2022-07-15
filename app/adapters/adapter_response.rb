# frozen_string_literal: true

class AdapterResponse
  attr_accessor :http_response

  def initialize(http_response)
    @http_response = http_response
  end

  def data
    @data ||= JSON.parse(http_response.body, symbolize_names: true)
    @data
  end

  def code
    data[:errors].present? ? 400 : http_response.code
  end

  def body
    http_response.body
  end

  def success?
    code == 200
  end

  def failure?
    code != 200
  end  

  def cursor
    data[:extra][:cursor] if data[:extra]
  end

  def until
    data[:extra][:until] if data[:extra]
  end
end
