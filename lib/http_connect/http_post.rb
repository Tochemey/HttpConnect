require 'http_connect/http_request'

module HttpConnect
  # HttpPost class
  class HttpPost < HttpRequest
    # initialize()
    def initialize(path, content_type = 'application/json',
                   accept = 'application/json', content = {})
      super(path, 'POST', content_type, accept, content)
    end
  end
end
