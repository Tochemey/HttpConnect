module HttpConnect
  # HttpResponse class
  class HttpResponse
    attr_reader :status_code # http status code
    attr_reader :body # http response body
    attr_reader :headers # http response headers
    def initialize(status_code, body, headers = {})
      @status_code = status_code
      @body = body
      @headers = headers
    end
  end
end
