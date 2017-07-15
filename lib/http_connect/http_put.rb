require 'http_connect/http_request'

module HttpConnect
  # HttpPut class
  class HttpPut < HttpRequest
    # initialize()
    def initialize(path, content_type = 'application/json',
                   accept = 'application/json', content = {})
      super(path, 'PUT', content_type, accept, content)
    end
  end
end
