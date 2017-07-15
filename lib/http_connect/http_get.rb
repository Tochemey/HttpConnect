require 'http_connect/http_request'

module HttpConnect
  # HttpGet class
  class HttpGet < HttpRequest
    # initialize()
    def initialize(path, content_type = 'application/json',
                   accept = 'application/json', content = {})
      super(path, 'GET', content_type, accept, content)
    end
  end
end
